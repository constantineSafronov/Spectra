//
//  FeedFeatureTests.swift
//  Spectra
//
//  Created by Konstantin Safronov on 24.10.2025.
//

import XCTest
import ComposableArchitecture
@testable import Spectra

@MainActor
final class FeedFeatureTests: XCTestCase {
  
  func testCategorySelection() async {
    let store = TestStore(initialState: FeedFeature.State()) {
      FeedFeature()
    } withDependencies: {
      $0.unsplashClient.search = { query, page in
        SearchResponse(total: 1, totalPages: 1, results: [.mock])
      }
    }
    
    await store.send(.categorySelected(.nature)) {
      $0.selectedCategory = .nature
      $0.isLoading = true
    }
    
    await store.receive(.feedResponse(.success(SearchResponse(
      total: 1, totalPages: 1, results: [.mock]
    )))) {
      $0.isLoading = false
      $0.photoList = [.mock]
      $0.categoryStates[.nature] = FeedFeature.CategoryState(
        category: .nature,
        photos: [.mock],
        page: 1
      )
    }
  }
  
  func testLoadMore() async {
    let store = TestStore(initialState: FeedFeature.State(
      selectedCategory: .nature,
      photoList: [.mock],
      categoryStates: [
        .nature: FeedFeature.CategoryState(
          category: .nature,
          photos: [.mock],
          page: 1
        )
      ]
    )) {
      FeedFeature()
    } withDependencies: {
      $0.unsplashClient.search = { query, page in
        SearchResponse(total: 2, totalPages: 2, results: [.mock2])
      }
    }
    
    await store.send(.loadMore) {
      $0.isLoading = true
    }
    
    await store.receive(.loadMoreResponse(.success(SearchResponse(
      total: 2, totalPages: 2, results: [.mock2]
    )))) {
      $0.isLoading = false
      $0.photoList = [.mock, .mock2]
      $0.categoryStates[.nature] = FeedFeature.CategoryState(
        category: .nature,
        photos: [.mock, .mock2],
        page: 2
      )
    }
  }
  
  func testCachedCategorySelection() async {
    let store = TestStore(initialState: FeedFeature.State(
      selectedCategory: .nature,
      photoList: [.mock],
      categoryStates: [
        .city: FeedFeature.CategoryState(
          category: .city,
          photos: [.mock2],
          page: 1
        )
      ]
    )) {
      FeedFeature()
    }
    
    await store.send(.categorySelected(.city)) {
      $0.selectedCategory = .city
      $0.photoList = [.mock2]
    }
  }
}
