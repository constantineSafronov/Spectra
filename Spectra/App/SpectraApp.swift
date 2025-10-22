//
//  SpectraApp.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct UnsplashImageLoaderApp: App {
  
  @StateObject private var styleService: StyleService
  let store: StoreOf<AppFeature>
  
  init() {
    UserDefaults.standard.register(defaults: [
      AppStorageKeys.appTheme: AppTheme.dark.rawValue,
      AppStorageKeys.showAuthorName: true,
      AppStorageKeys.showPhotoDescription: true,
      AppStorageKeys.useTechnologyStyle: false
    ])
    
    let appStore = Store(initialState: AppFeature.State()) {
      AppFeature()
    }
    self.store = appStore
    
    let settingsStore = appStore.scope(
      state: \.settings,
      action: \.settings
    )
    self._styleService = StateObject(wrappedValue: StyleService(store: settingsStore))
  }
  
  var body: some Scene {
    WindowGroup {
      MainView(store: store)
        .environmentObject(styleService)
    }
  }
  
}
