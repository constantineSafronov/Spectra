//
//  FavoritePhotoClient.swift
//  Spectra
//
//  Created by Konstantin Safronov on 23.10.2025.
//

import ComposableArchitecture
import SwiftData
import PhotosUI
import UIKit

enum PhotoLibraryError: Error, LocalizedError {
  case invalidURL
  case imageLoadingGenericError
  
  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "Invalid URL"
    case .imageLoadingGenericError:
      return "Loading error"
    }
  }
}

struct FavoritePhotoClient {
  var fetchFavorites: @Sendable () async throws -> [FavoritePhotoDTO]
  var delete: @Sendable (FavoritePhotoDTO) async throws -> Void
  var saveToLibrary: @Sendable (FavoritePhotoDTO) async -> FavoritesFeature.Action.SaveResult
}

extension DependencyValues {
  var favoritePhotoClient: FavoritePhotoClient {
    get { self[FavoritePhotoClientKey.self] }
    set { self[FavoritePhotoClientKey.self] = newValue }
  }
}

private enum FavoritePhotoClientKey: DependencyKey {
  static let liveValue: FavoritePhotoClient = .noop
}

extension FavoritePhotoClient {
  static let noop = FavoritePhotoClient(
    fetchFavorites: { [] },
    delete: { _ in },
    saveToLibrary: { _ in
        .failure("No client configured")
    }
  )
}

private class WeakContextRef {
  weak var context: ModelContext?
  
  init(context: ModelContext) {
    self.context = context
  }
}


extension FavoritePhotoClient {
  static func live(context: ModelContext) -> FavoritePhotoClient {
    let contextRef = WeakContextRef(context: context)
    
    return FavoritePhotoClient(
      fetchFavorites: {
        await MainActor.run {
          guard let context = contextRef.context else { return [] }
          do {
            let descriptor = FetchDescriptor<FavoritePhoto>()
            let photos = try context.fetch(descriptor)
            return photos.map { $0.toDTO() }
          } catch {
            return []
          }
        }
      },
      delete: { photoDTO in
        await MainActor.run {
          guard let context = contextRef.context else { return }
          do {
            let photoId = photoDTO.id
            let descriptor = FetchDescriptor<FavoritePhoto>(
              predicate: #Predicate<FavoritePhoto> { favorite in
                favorite.id == photoId
              }
            )
            if let photo = try context.fetch(descriptor).first {
              context.delete(photo)
              try context.save()
            }
          } catch {
            print("Error deleting photo: \(error)")
          }
        }
      },
      saveToLibrary: { photo in
        guard let url = URL(string: photo.fullURL) else {
          return .failure(PhotoLibraryError.invalidURL.localizedDescription)
        }
        do {
          let (data, _) = try await URLSession.shared.data(from: url)
          guard let image = UIImage(data: data) else {
            return .failure(PhotoLibraryError.imageLoadingGenericError.localizedDescription)
          }
          
          let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
          if status == .notDetermined {
            _ = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
          }
          
          return await withCheckedContinuation { continuation in
            PHPhotoLibrary.shared().performChanges({
              PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
              if success {
                continuation.resume(returning: .success(LocalizedStrings.Common.savePhotoMessage.localized))
              } else {
                let errorMessage = error?.localizedDescription ?? PhotoLibraryError.imageLoadingGenericError.localizedDescription
                continuation.resume(returning: .failure(errorMessage))
              }
            }
          }
        } catch {
          return .failure(error.localizedDescription)
        }
      }
    )
  }
  
}
