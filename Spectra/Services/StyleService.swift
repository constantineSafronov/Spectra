//
//  StyleService.swift
//  Spectra
//
//  Created by Konstantin Safronov on 21.10.2025.
//

import SwiftUI
import Combine
import ComposableArchitecture

final class StyleService: ObservableObject {
  
  @Published private var useTechnologyStyle: Bool = false
  @Published private(set) var showAuthorName: Bool = true
  @Published private(set) var showDescription: Bool = true
  
  private var cancellables: Set<AnyCancellable> = []
  
  init(store: StoreOf<SettingsFeature>) {
    initializeBindings(store: store)
  }
  
  private func initializeBindings(store: StoreOf<SettingsFeature>) {
    store.publisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        self?.useTechnologyStyle = state.useTechnologyStyle
        self?.showAuthorName = state.showAuthorName
        self?.showDescription = state.showDescription
      }
      .store(in: &cancellables)
  }
  
  // MARK: - Fonts
  
  var titleFont: Font {
    return useTechnologyStyle ? Font.custom("Technology-Bold", size: 20) : Font.subheadline.bold()
  }
  
  var descriptionFont: Font {
    useTechnologyStyle ? Font.custom("Technology-Regular", size: 16) : Font.footnote
  }
  
  var controlsFont: Font {
    useTechnologyStyle ? Font.custom("Technology-Bold", size: 18) : Font.headline
  }
  
  var largeTitleFont: Font {
    useTechnologyStyle ? Font.custom("Technology-Bold", size: 36) : .largeTitle.bold()
  }
  
  var searchBarFont: Font {
    useTechnologyStyle ? Font.custom("Technology-Bold", size: 20) : Font.subheadline.bold()
  }
  
  var pickerItemFont: Font {
    useTechnologyStyle ? Font.custom("Technology-Bold", size: 15) : Font.subheadline.bold()
  }
    
}
