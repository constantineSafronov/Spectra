//
//  PhotoLibraryClient.swift
//  Spectra
//
//  Created by Konstantin Safronov on 24.10.2025.
//

import Photos
import SwiftUI
import ComposableArchitecture
import SwiftData

struct PhotoLibraryClient {
  var saveToLibrary: @Sendable (URL?) async -> SaveResult
}

extension PhotoLibraryClient {
  enum SaveResult: Equatable {
    case success(String)
    case failure(String)
  }
}

extension DependencyValues {
  var photoLibraryClient: PhotoLibraryClient {
    get { self[PhotoLibraryClientKey.self] }
    set { self[PhotoLibraryClientKey.self] = newValue }
  }
}

private enum PhotoLibraryClientKey: DependencyKey {
  static let liveValue: PhotoLibraryClient = .fake
}

extension PhotoLibraryClient {
  static let fake = PhotoLibraryClient(
    saveToLibrary: { _ in .failure("No PhotoLibraryClient configured") }
  )
}

extension PhotoLibraryClient {
  static func live() -> PhotoLibraryClient {
    PhotoLibraryClient(
      saveToLibrary: { url in
        guard let url else {
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
