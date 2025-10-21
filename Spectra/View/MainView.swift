//
//  MainView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import SwiftUI
import SwiftData

struct MainView: View {
  
  @StateObject private var styleService = StyleService()
  
  @AppStorage(AppStorageKeys.appTheme) var appTheme: AppTheme = .system
  @AppStorage(AppStorageKeys.useTechnologyStyle) private var useTechNologyStyle: Bool = false
  
  var body: some View {
    contentView()
  }
  
  func contentView() -> some View {
    TabView {
      FeedView(model: FeedModel())
        .tabItem {
          Label("Feed", systemImage: "photo.on.rectangle")
        }
      SearchView(model: SearchModel())
        .tabItem {
          Label("Search", systemImage: "magnifyingglass")
        }
      FavoritesView(model: FavoritesModel())
        .tabItem {
          Label("Favorites", systemImage: "heart")
        }
      SettingsView()
        .tabItem {
          Label("Settings", systemImage: "gearshape")
        }
    }
    .tint(.black)
    .modelContainer(for: FavoritePhoto.self)
    .environmentObject(styleService)
    .preferredColorScheme(appTheme == .system ? nil :
                            (appTheme == .light ? .light : .dark))
  }

}
