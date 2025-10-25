//
//  SearchFeatureTests.swift
//  Spectra
//
//  Created by Konstantin Safronov on 24.10.2025.
//

import XCTest
import ComposableArchitecture
@testable import Spectra

@MainActor
final class SearchFeatureTests: XCTestCase {
  
  func testSearchSuccess() async {
    let store = TestStore(initialState: SearchFeature.State()) {
      SearchFeature()
    } withDependencies: {
      $0.unsplashClient.search = { query, page in
        SearchResponse(
          total: 1,
          totalPages: 1,
          results: [.mock]
        )
      }
    }
    
    await store.send(.searchTextChanged("cats")) {
      $0.searchText = "cats"
      $0.isLoading = true
      $0.currentPage = 1
    }
    
    await store.receive(.searchResponse(.success(SearchResponse(
      total: 1,
      totalPages: 1,
      results: [.mock]
    )))) {
      $0.isLoading = false
      $0.photoList = [.mock]
    }
  }
  
  func testClearSearch() async {
    let store = TestStore(initialState: SearchFeature.State(
      searchText: "test",
      photoList: [.mock],
      currentPage: 2
    )) {
      SearchFeature()
    }
    
    await store.send(.searchTextChanged("")) {
      $0.searchText = ""
      $0.photoList = []
      $0.currentPage = 1
    }
  }
  
  func testLoadMore() async {
    let store = TestStore(initialState: SearchFeature.State(
      searchText: "nature",
      photoList: [.mock],
      isLoading: false,
      currentPage: 1
      
    )) {
      SearchFeature()
    } withDependencies: {
      $0.unsplashClient.search = { query, page in
        SearchResponse(
          total: 10,
          totalPages: 5,
          results: [.mock2]
        )
      }
    }
    
    await store.send(.loadMore) {
      $0.isLoading = true
    }
    
    await store.receive(.loadMoreResponse(.success(SearchResponse(
      total: 10,
      totalPages: 5,
      results: [.mock2]
    )))) {
      $0.isLoading = false
      $0.currentPage = 2
      $0.photoList = [.mock, .mock2]
    }
  }
  
}

extension Photo {
  static let mock = Photo(
    id: "1",
    altDescription: "Mock photo 1",
    urls: Urls(
      thumb: "https://example.com/thumb1.jpg",
      small: "https://example.com/small1.jpg",
      regular: "https://example.com/regular1.jpg",
      full: "https://example.com/full1.jpg"
    ),
    width: 4000,
    height: 3000,
    user: User(
      id: "user1",
      name: "Mock User 1",
      username: "mockuser1"
    )
  )
  
  static let mock2 = Photo(
    id: "2",
    altDescription: "Mock photo 2",
    urls: Urls(
      thumb: "https://example.com/thumb2.jpg",
      small: "https://example.com/small2.jpg",
      regular: "https://example.com/regular2.jpg",
      full: "https://example.com/full2.jpg"
    ),
    width: 5000,
    height: 3333,
    user: User(
      id: "user2",
      name: "Mock User 2",
      username: "mockuser2"
    )
  )
}

extension SearchResponse {
  static let mock = SearchResponse(
    total: 2,
    totalPages: 1,
    results: [.mock, .mock2]
  )
}
