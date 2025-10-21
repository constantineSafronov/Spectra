//
//  SearchModel.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import SwiftUI
import Combine

@MainActor final class SearchModel: ObservableObject {
  
  private var cancellables: Set<AnyCancellable> = []
  private var isLoadingInProgress: Bool = false
  private var page: Int = 1
  
  @Published var searchText: String = ""
  @Published var localizedError: String = ""
  @Published var showsError: Bool = false
  @Published var isLoadingNeeded: Bool = false {
    didSet {
      guard isLoadingNeeded && !isLoadingInProgress && !searchText.isEmpty else { return }
      
      page = page + 1
      Task {
        await loadFeed()
      }
    }
  }
  
  @Published var photoList = [Photo]()
  
  init() {
    initializeBindings()
  }
  
  private func initializeBindings() {
    $searchText
      .removeDuplicates()
      .debounce(for: .seconds(1), scheduler: RunLoop.main)
      .sink { [weak self] text in
        guard let self else { return }
        
        if text.isEmpty {
          self.page = 1
          self.photoList.removeAll()
        } else {
          self.page = 1
          self.photoList.removeAll()
          Task {
            await self.loadFeed()
          }
        }
      }
      .store(in: &cancellables)
  }
  
  private func loadFeed() async {
    guard !isLoadingInProgress else { return }
    
    isLoadingInProgress = true
    do {
      let api = UnsplashAPI.feed(
        category: searchText,
        page: page
      )
      let feed = try await URLSession.shared.data(from: api)
      
      photoList.append(contentsOf: feed.results)
      isLoadingNeeded = false
      isLoadingInProgress = false
    } catch {
      localizedError = error.localizedDescription
      showsError = true
    }
  }
  
}
