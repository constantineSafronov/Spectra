//
//  FeedFeature.swift
//  Spectra
//
//  Created by Konstantin Safronov on 24.10.2025.
//
import Foundation
import ComposableArchitecture

@Reducer
struct FeedFeature {
  @ObservableState
  struct State: Equatable {
    var selectedCategory: Category = .allCases.first!
    var photoList: [Photo] = []
    var isLoading = false
    var error: String?
    var showsError = false
    var categoryStates: [Category: CategoryState] = [:]
    var photoDetail: PhotoDetailFeature.State?
  }

  struct CategoryState: Equatable {
    let category: Category
    let photos: [Photo]
    let page: Int
  }

  enum Action: Equatable {
    case onAppear
    case categorySelected(Category)
    case feedResponse(TaskResult<SearchResponse>)
    case loadMore
    case loadMoreResponse(TaskResult<SearchResponse>)
    case photoSelected(Photo)
    case detailDismissed
    case errorDismissed
    case photoDetail(PhotoDetailFeature.Action)
  }

  @Dependency(\.unsplashClient) var unsplashClient

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        if state.categoryStates[state.selectedCategory] == nil {
          state.isLoading = true
          return .run { [category = state.selectedCategory] send in
            await send(.feedResponse(await TaskResult {
              try await unsplashClient.search(category.rawValue, 1)
            }))
          }
        }
        return .none

      case let .categorySelected(category):
        state.selectedCategory = category

        if let categoryState = state.categoryStates[category] {
          state.photoList = categoryState.photos
        } else {
          state.isLoading = true
          state.photoList = []
          return .run { send in
            await send(.feedResponse(await TaskResult {
              try await unsplashClient.search(category.rawValue, 1)
            }))
          }
        }
        return .none

      case let .feedResponse(.success(response)):
        state.isLoading = false
        state.photoList = response.results

        state.categoryStates[state.selectedCategory] = CategoryState(
          category: state.selectedCategory,
          photos: response.results,
          page: 1
        )
        return .none

      case let .feedResponse(.failure(error)):
        state.isLoading = false
        state.error = error.localizedDescription
        state.showsError = true
        return .none

      case .loadMore:
        guard !state.isLoading, let currentState = state.categoryStates[state.selectedCategory] else {
          return .none
        }

        state.isLoading = true
        let nextPage = currentState.page + 1

        return .run { [category = state.selectedCategory] send in
          await send(.loadMoreResponse(await TaskResult {
            try await unsplashClient.search(category.rawValue, nextPage)
          }))
        }

      case let .loadMoreResponse(.success(response)):
        state.isLoading = false

        let updatedPhotos = state.photoList + response.results
        state.photoList = updatedPhotos
        state.categoryStates[state.selectedCategory] = CategoryState(
          category: state.selectedCategory,
          photos: updatedPhotos,
          page: (state.categoryStates[state.selectedCategory]?.page ?? 1) + 1
        )
        return .none

      case let .loadMoreResponse(.failure(error)):
        state.isLoading = false
        state.error = error.localizedDescription
        state.showsError = true
        return .none

      case let .photoSelected(photo):
        state.photoDetail = PhotoDetailFeature.State(photo: photo)
        return .none

      case .detailDismissed:
        state.photoDetail = nil
        return .none

      case .errorDismissed:
        state.showsError = false
        state.error = nil
        return .none

      case .photoDetail(let childAction):
        switch childAction {
        case .dismissRequested:
          state.photoDetail = nil
          
          return .none
        default:
          return .none
        }
      }
    }
    .ifLet(\.photoDetail, action: \.photoDetail) {
        PhotoDetailFeature()
    }
  }
}
