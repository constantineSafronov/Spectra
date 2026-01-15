//
//  SearchFeature.swift
//  Spectra
//
//  Created by Konstantin Safronov on 24.10.2025.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct SearchFeature {
  @ObservableState
  struct State: Equatable {
    var searchText = ""
    var photoList: [Photo] = []
    var isLoading = false
    var error: String?
    var currentPage = 1
    var showsError = false
    var photoDetail: PhotoDetailFeature.State?
  }
  
  @Dependency(\.unsplashClient) var unsplashClient
  
  enum Action: Equatable {
    case searchTextChanged(String)
    case searchResponse(TaskResult<SearchResponse>)
    case loadMore
    case loadMoreResponse(TaskResult<SearchResponse>)
    case photoSelected(Photo)
    case detailDismissed
    case errorDismissed
    case photoDetail(PhotoDetailFeature.Action)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .searchTextChanged(text):
        state.searchText = text
        
        guard !text.isEmpty else {
          state.photoList = []
          state.currentPage = 1
          return .cancel(id: "search")
        }
        
        state.currentPage = 1
        state.isLoading = true
        
        return .run { send in
          try await Task.sleep(nanoseconds: 1_000_000_000)
          await send(.searchResponse(await TaskResult {
            try await unsplashClient.search(text, 1)
          }))
        }
        .cancellable(id: "search")
        
      case let .searchResponse(.success(response)):
        state.isLoading = false
        state.photoList = response.results
        return .none
        
      case let .searchResponse(.failure(error)):
        state.isLoading = false
        state.error = error.localizedDescription
        state.showsError = true
        return .none
        
      case .loadMore:
        guard !state.isLoading, !state.searchText.isEmpty else { return .none }
        
        state.isLoading = true
        let nextPage = state.currentPage + 1
        
        return .run { [searchText = state.searchText] send in
          await send(.loadMoreResponse(await TaskResult {
            try await unsplashClient.search(searchText, nextPage)
          }))
        }
        
      case let .loadMoreResponse(.success(response)):
        state.isLoading = false
        state.currentPage += 1
        state.photoList.append(contentsOf: response.results)
        return .none
        
      case let .loadMoreResponse(.failure(error)):
        state.isLoading = false
        state.error = error.localizedDescription
        state.showsError = true
        return .none
        
      case let .photoSelected(photo):
        state.photoDetail = PhotoDetailFeature.State(photo: photo)
        return .none
        
      case .photoDetail(let childAction):
        switch childAction {
        case .dismissRequested:
          state.photoDetail = nil
          
          return .none
        default:
          return .none
        }
      case .detailDismissed:
        return .none
        
      case .errorDismissed:
        state.showsError = false
        state.error = nil
        return .none
      }
    }
    .ifLet(\.photoDetail, action: \.photoDetail) {
        PhotoDetailFeature()
    }
  }
}
