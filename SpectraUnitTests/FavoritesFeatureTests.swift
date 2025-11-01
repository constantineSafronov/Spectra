//
//  FavoritesFeatureTests.swift
//  Spectra
//
//  Created by Konstantin Safronov on 23.10.2025.
//

import XCTest
import ComposableArchitecture
import SwiftData
@testable import Spectra

@MainActor
final class FavoritesFeatureTests: XCTestCase {
  
  private var modelContainer: ModelContainer!
  private var modelContext: ModelContext!
  
  override func setUp() async throws {
    modelContainer = try ModelContainer(
      for: FavoritePhoto.self,
      configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    modelContext = modelContainer.mainContext
  }
  
  override func tearDown() async throws {
    modelContainer = nil
    modelContext = nil
  }
  
  func testOnAppearLoadsFavoritesFromDatabase() async {
    let photo1 = FavoritePhoto(
      id: "photo1",
      userName: "User 1",
      smallURL: "https://www.lavanguardia.com/files/og_thumbnail/uploads/2018/01/18/5fa4323b59be3.jpeg",
      fullURL: "https://www.lavanguardia.com/files/og_thumbnail/uploads/2018/01/18/5fa4323b59be3.jpeg",
      width: 100,
      height: 100
    )
    let photo2 = FavoritePhoto(
      id: "photo2",
      userName: "User 2",
      smallURL: "https://www.lavanguardia.com/files/og_thumbnail/uploads/2018/01/18/5fa4323b59be3.jpeg",
      fullURL: "https://www.lavanguardia.com/files/og_thumbnail/uploads/2018/01/18/5fa4323b59be3.jpeg",
      width: 200,
      height: 200
    )
    
    modelContext.insert(photo1)
    modelContext.insert(photo2)
    try! modelContext.save()
    
    let store = TestStore(initialState: FavoritesFeature.State()) {
      FavoritesFeature()
    } withDependencies: {
      $0.favoritePhotoClient = FavoritePhotoClient.live(context: self.modelContext)
    }
    
    store.exhaustivity = .off
    await store.send(.onAppear) {
      $0.favorites = []
    }
    
    await store.receive(.favoritesResponse([photo1.toDTO(), photo2.toDTO()]), timeout: .seconds(8)) {
      
      $0.favorites = [photo1.toDTO(), photo2.toDTO()]
    }
  }
  
  func testDeletePhotoRemovesFromDatabase() async {
    let photo = FavoritePhoto(
      id: "test-delete",
      userName: "Test User",
      smallURL: "https://www.lavanguardia.com/files/og_thumbnail/uploads/2018/01/18/5fa4323b59be3.jpeg",
      fullURL: "https://www.lavanguardia.com/files/og_thumbnail/uploads/2018/01/18/5fa4323b59be3.jpeg",
      width: 100,
      height: 100
    )
    modelContext.insert(photo)
    try! modelContext.save()
    
    let store = TestStore(
      initialState: FavoritesFeature.State(favorites: [photo.toDTO()])
    ) {
      FavoritesFeature()
    } withDependencies: {
      $0.favoritePhotoClient = FavoritePhotoClient.live(context: self.modelContext)
    }
    
    await store.send(.deletePhoto(photo.toDTO()))
    
    await store.receive(.favoritesResponse([])) {
      $0.favorites = []
    }
    
    let descriptor = FetchDescriptor<FavoritePhoto>()
    let remainingPhotos = try! modelContext.fetch(descriptor)
    XCTAssertTrue(remainingPhotos.isEmpty, "Photo should be removed from database")
  }
  
  func testSaveToLibraryWithRealPhoto() async {
    let photoDTO = FavoritePhotoDTO(
      id: "save",
      smallURL: "https://images.unsplash.com/photo-1541963463532-d68292c34b19",
      fullURL: "https://images.unsplash.com/photo-1541963463532-d68292c34b19",
      userName: "https://www.lavanguardia.com/files/og_thumbnail/uploads/2018/01/18/5fa4323b59be3.jpeg",
      photoDescription: "Test",
      width: 1000,
      height: 800
    )
    
    let store = TestStore(
      initialState: FavoritesFeature.State(favorites: [photoDTO])
    ) {
      FavoritesFeature()
    } withDependencies: {
      $0.photoLibraryClient.saveToLibrary = { _ in
        return .success("Photo saved to library")
      }
    }
    
    await store.send(.saveToLibrary(photoDTO)) {
      $0.isSaving = true
    }
    
    await store.receive(.saveFinished(.success("Photo saved to library"))) {
      $0.isSaving = false
      $0.alert = "Photo saved to library"
    }
  }
  
  func testEmptyStateWhenNoFavorites() async {
    let store = TestStore(initialState: FavoritesFeature.State()) {
      FavoritesFeature()
    } withDependencies: {
      $0.favoritePhotoClient.fetchFavorites = { [] }
      $0.favoritePhotoClient.delete = { _ in }
    }
    
    await store.send(.onAppear)
    await store.receive(.favoritesResponse([]))
    
    XCTAssertTrue(store.state.favorites.isEmpty)
  }
}
