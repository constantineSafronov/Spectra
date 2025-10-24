//
//  FavoritesFeature.swift
//  Spectra
//
//  Created by Konstantin Safronov on 23.10.2025.
//

import ComposableArchitecture
import SwiftData
import PhotosUI

@Reducer
struct FavoritesFeature {
  @ObservableState
  struct State: Equatable {
    var favorites: [FavoritePhotoDTO] = []
    var alert: String?
    var isSaving: Bool = false
  }
  
  enum Action: Equatable {
    case onAppear
    case favoritesResponse([FavoritePhotoDTO])
    case deletePhoto(FavoritePhotoDTO)
    case saveToLibrary(FavoritePhotoDTO)
    case saveFinished(PhotoLibraryClient.SaveResult)
    case dismissAlert
    
    enum SaveResult: Equatable {
      case success(String)
      case failure(String)
    }
  }
  
  @Dependency(\.favoritePhotoClient) var favoriteClient
  @Dependency(\.photoLibraryClient) var photoLibraryClient
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          let photos = try await favoriteClient.fetchFavorites()
          await send(.favoritesResponse(photos))
        }
        
      case .favoritesResponse(let photos):
        state.favorites = photos
        
        return .none
        
      case .deletePhoto(let photo):
        return .run { send in
          try await favoriteClient.delete(photo)
          let updatedPhotos = try await favoriteClient.fetchFavorites()
          await send(.favoritesResponse(updatedPhotos))
        }
        
      case .saveToLibrary(let photo):
        state.isSaving = true
        return .run { send in
          let result = await photoLibraryClient.saveToLibrary(URL(string: photo.fullURL))
          await send(.saveFinished(result))
        }
        
      case .saveFinished(let result):
        state.isSaving = false
        switch result {
        case .success(let message):
          state.alert = message
        case .failure(let errorMessage):
          state.alert = errorMessage
        }
        
        return .none
        
      case .dismissAlert:
        state.alert = nil
        
        return .none
      }
    }
  }
}
