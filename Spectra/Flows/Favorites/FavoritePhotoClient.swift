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
}

extension DependencyValues {
  var favoritePhotoClient: FavoritePhotoClient {
    get { self[FavoritePhotoClientKey.self] }
    set { self[FavoritePhotoClientKey.self] = newValue }
  }
}

private enum FavoritePhotoClientKey: DependencyKey {
  static let liveValue: FavoritePhotoClient = .fake
}

extension FavoritePhotoClient {
  static let fake = FavoritePhotoClient(
    fetchFavorites: { [] },
    delete: { _ in }
  )
}

class WeakContextRef {
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
      }
    )
  }
}
