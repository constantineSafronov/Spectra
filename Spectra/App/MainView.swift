//
//  MainView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

struct MainView: View {
  let store: StoreOf<AppFeature>
  
  var body: some View {
    contentView()
  }
  
  func contentView() -> some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      TabView {
        FeedView(model: FeedModel())
          .tabItem {
            Label("Feed", systemImage: "photo.on.rectangle")
          }
        
        SearchView(model: SearchModel())
          .tabItem {
            Label("Search", systemImage: "magnifyingglass")
          }
        
        FavoritesView()
          .tabItem {
            Label("Favorites", systemImage: "heart")
          }
        
        SettingsView(
          store: store.scope(
            state: \.settings,
            action: \.settings
          )
        )
        .tabItem {
          Label("Settings", systemImage: "gearshape")
        }
      }
      .tint(.black)
      .modelContainer(for: FavoritePhoto.self)
      .preferredColorScheme(
        viewStore.settings.appTheme == .system ? nil :
          (viewStore.settings.appTheme == .light ? .light : .dark)
      )
    }
  }
  
}
