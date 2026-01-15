//
//  PhotoDetailClient.swift
//  Spectra
//
//  Created by Konstantin Safronov on 24.10.2025.
//

import Photos
import SwiftUI
import ComposableArchitecture
import SwiftData

struct PhotoDetailClient {
  var checkFavoriteStatus: @Sendable (String) async -> Bool
  var toggleFavorite: @Sendable (Photo) async -> Void
}

extension PhotoDetailClient {
  enum SaveResult: Equatable {
    case success(String)
    case failure(String)
  }
}

extension DependencyValues {
  var photoDetailClient: PhotoDetailClient {
    get { self[PhotoDetailClientKey.self] }
    set { self[PhotoDetailClientKey.self] = newValue }
  }
}

private enum PhotoDetailClientKey: DependencyKey {
  static let liveValue: PhotoDetailClient = .fake
}

extension PhotoDetailClient {
  static let fake = PhotoDetailClient(
    checkFavoriteStatus: { _ in false },
    toggleFavorite: { _ in }
  )
}

extension PhotoDetailClient {
  static func live(context: ModelContext) -> PhotoDetailClient {
    let contextRef = WeakContextRef(context: context)
    
    return PhotoDetailClient(      
      checkFavoriteStatus: { photoId in
        await MainActor.run {
          guard let context = contextRef.context else { return false }
          do {
            let descriptor = FetchDescriptor<FavoritePhoto>(
              predicate: #Predicate<FavoritePhoto> { favorite in
                favorite.id == photoId
              }
            )
            let favorites = try context.fetch(descriptor)
            
            return !favorites.isEmpty
          } catch {
            return false
          }
        }
      },
      
      toggleFavorite: { photo in
        await MainActor.run {
          guard let context = contextRef.context else { return }
          do {
            let descriptor = FetchDescriptor<FavoritePhoto>(
              predicate: #Predicate<FavoritePhoto> { favorite in
                favorite.id == photo.id
              }
            )
            let existingFavorites = try context.fetch(descriptor)
            
            if let existingFavorite = existingFavorites.first {
              context.delete(existingFavorite)
            } else {
              let favoritePhoto = FavoritePhoto(with: photo)
              context.insert(favoritePhoto)
            }
            try? context.save()
          } catch {
            print("Error toggling favorite: \(error)")
          }
        }
      }
    )
  }
}
