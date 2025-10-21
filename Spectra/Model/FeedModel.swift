//
//  FeedModel.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import SwiftUI
import Combine

enum Category: String, CaseIterable, Identifiable {
  case backgrounds
  case architecture
  case vibe
  case nightlife
  case cyberpunk
  case nature
  case city
  case people
  
  var id: String { rawValue }
}

struct CategoryState {
  let category: Category
  let photos: [Photo]
  let page: Int
}

@MainActor final class FeedModel: ObservableObject {
  
  private var categoryStates = [Category: CategoryState]()
  private var isLoadingInProgress: Bool = false
  
  @Published var photoList = [Photo]()
  @Published var localizedError: String = ""
  @Published var showsError: Bool = false
  @Published var selectedCategory = Category.allCases.first! {
    didSet {
      self.photoList = categoryStates[selectedCategory]?.photos ?? []
    }
  }
  @Published var isLoadingNeeded: Bool = false {
    didSet {
      guard isLoadingNeeded && !isLoadingInProgress else { return }
      
      if !photoList.isEmpty {
        updateSelectedCategory(
          category: selectedCategory,
          page: currentPage + 1,
          photos: photoList
        )
      }
      Task {
        await loadFeed()
      }
    }
  }
  
  private func loadFeed() async {
    guard !isLoadingInProgress else { return }
    
    isLoadingInProgress = true
    do {
      let api = UnsplashAPI.feed(
        category: selectedCategory.rawValue,
        page: currentPage
      )
      let feed = try await URLSession.shared.data(from: api)
      photoList.append(contentsOf: feed.results)
      isLoadingNeeded = false
      isLoadingInProgress = false
      updateSelectedCategory(category: selectedCategory, page: currentPage, photos: photoList)
    } catch {
      localizedError = error.localizedDescription
      showsError = true
    }
  }
  
  private func updateSelectedCategory(category: Category, page: Int, photos: [Photo]) {
    categoryStates[selectedCategory] = CategoryState(
      category: category,
      photos: photos,
      page: page
    )
  }
  
}

extension FeedModel {
  
  private var currentPage: Int {
    categoryStates[selectedCategory]?.page ?? 1
  }
  
}
