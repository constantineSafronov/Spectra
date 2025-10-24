//
//  PhotoDetailFeature.swift
//  Spectra
//
//  Created by Konstantin Safronov on 24.10.2025.
//

import SwiftUI
import SwiftData
import Foundation
import ComposableArchitecture
import CoreGraphics

struct PhotoDetailFeature: Reducer {
  struct State: Equatable {
    var photo: Photo
    var isFavorite: Bool = false
    var isSaving: Bool = false
    var saveResultMessage: String?
    var showsSaveResult: Bool = false
    var onDismiss: Bool = false
    var dragOffset: CGFloat = 0
  }

  enum Action: Equatable {
    case onAppear
    case checkFavoriteStatus
    case favoriteStatusLoaded(Bool)
    case toggleFavorite
    case saveToLibrary
    case saveResponse(PhotoLibraryClient.SaveResult)
    case dismissSaveResult
    case dragChanged(CGFloat)
    case dragEnded(CGFloat)
    case dismissRequested
  }

  @Dependency(\.photoDetailClient) var photoDetailsClient
  @Dependency(\.photoLibraryClient) var photoLibraryClient

  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .send(.checkFavoriteStatus)

    case .checkFavoriteStatus:
      return .run { [photoId = state.photo.id] send in
        let isFavorite = await photoDetailsClient.checkFavoriteStatus(photoId)
        await send(.favoriteStatusLoaded(isFavorite))
      }

    case let .favoriteStatusLoaded(isFavorite):
      state.isFavorite = isFavorite
      return .none

    case .toggleFavorite:
      return .run { [photo = state.photo] send in
        await photoDetailsClient.toggleFavorite(photo)
        let isFavorite = await photoDetailsClient.checkFavoriteStatus(photo.id)
        await send(.favoriteStatusLoaded(isFavorite))
      }

    case .saveToLibrary:
      state.isSaving = true
      return .run { [photo = state.photo] send in
        let result = await photoLibraryClient.saveToLibrary(URL(string: photo.urls.full))
        await send(.saveResponse(result))
      }

    case let .saveResponse(result):
      state.isSaving = false
      switch result {
      case .success(let message):
        state.saveResultMessage = message
      case .failure(let error):
        state.saveResultMessage = error
      }
      state.showsSaveResult = true
      return .none

    case .dismissSaveResult:
      state.showsSaveResult = false
      state.saveResultMessage = nil
      return .none

    case let .dragChanged(offset):
      state.dragOffset = offset
      return .none

    case let .dragEnded(offset):
      state.dragOffset = offset
      return .none

    case .dismissRequested:
      state.onDismiss = true
      return .none
    }
  }
}
