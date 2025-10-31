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
  @Environment(\.modelContext) private var modelContext
  
  var body: some View {
    contentView()
  }
  
  func contentView() -> some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      TabView {
        let feedStore = Store(
          initialState: FeedFeature.State(),
          reducer: {
            FeedFeature()
              .dependency(\DependencyValues.photoDetailClient, PhotoDetailClient.live(context: modelContext))
              .dependency(\.photoLibraryClient, PhotoLibraryClient.live())
          }
        )

        FeedView(
          store: feedStore,
          modelContext: modelContext
        )
        .tabItem {
          Label(LocalizedStrings.TabBar.feed.localized, systemImage: "photo.on.rectangle")
        }
        
        SearchView(
          store: Store(
            initialState: SearchFeature.State(),
            reducer: {
              SearchFeature()
                .dependency(\DependencyValues.photoDetailClient, PhotoDetailClient.live(context: modelContext))
                .dependency(\.photoLibraryClient, PhotoLibraryClient.live())
            }
          )
        )
        .tabItem {
          Label(LocalizedStrings.TabBar.search.localized, systemImage: "magnifyingglass")
        }
        
        FavoritesView(
          store: Store(
            initialState: FavoritesFeature.State(),
            reducer: {
              FavoritesFeature()
                .dependency(\.favoritePhotoClient, FavoritePhotoClient.live(context: modelContext))
                .dependency(\.photoLibraryClient, PhotoLibraryClient.live())
            }
          )
        )
        .tabItem {
          Label(LocalizedStrings.TabBar.favorites.localized, systemImage: "heart")
        }
        
        SettingsView(
          store: store.scope(
            state: \.settings,
            action: \.settings
          )
        )
        .tabItem {
          Label(LocalizedStrings.TabBar.settings.localized, systemImage: "gearshape")
        }
      }
      .tint(.black)
      .preferredColorScheme(
        viewStore.settings.appTheme == .system ? nil :
          (viewStore.settings.appTheme == .light ? .light : .dark)
      )
    }
  }
}
