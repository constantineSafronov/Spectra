//
//  SearchView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

struct SearchView: View {
  let store: StoreOf<SearchFeature>
  @Namespace private var animationNamespace
  @EnvironmentObject var style: StyleService
  let dismissingThreshold = 150.0

  
  init(store: StoreOf<SearchFeature>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack {
        NavigationView {
          ZStack {
            Color(.background)
              .ignoresSafeArea()
            
            VStack(spacing: 0) {
              searchBar(viewStore: viewStore)
                .padding(.top, 8)
              
              MasonryGridView(
                photos: viewStore.photoList,
                isLoading: viewStore.isLoading,
                animationNamespace: animationNamespace,
                onPhotoTap: { photo in
                  _ = withAnimation(.smooth) {
                    viewStore.send(.photoSelected(photo))
                  }
                },
                onLoadMore: {
                  viewStore.send(.loadMore)
                }
              )
              .padding(.top, 20.0)
            }
          }
          .navigationBarHidden(true)
        }
        .zIndex(0)
        
          IfLetStore(
            self.store.scope(
              state: \.photoDetail,
              action: \.photoDetail
            )
          ) { detailStore in
            PhotoDetailView(
              store: detailStore,
              namespace: animationNamespace,
              isPresented: Binding(
                get: { viewStore.photoDetail != nil },
                set: { isPresented in
                  if !isPresented {
                    viewStore.send(.detailDismissed)
                  }
                }
              )
            )
            .zIndex(1)
          }
      }
      .alert(
        viewStore.error ?? "",
        isPresented: Binding(
          get: { viewStore.showsError },
          set: { if !$0 { viewStore.send(.errorDismissed) } }
        )
      ) {
        Button(LocalizedStrings.Common.ok.localized.uppercased(), role: .cancel) {}
      }
    }
  }
  
  private func searchBar(viewStore: ViewStore<SearchFeature.State, SearchFeature.Action>) -> some View {
    ZStack {
      VisualEffectBlur(blurStyle: .systemMaterial)
        .frame(height: 56)
        .cornerRadius(23)
        .padding(.horizontal)
      
      HStack {
        Image(systemName: "magnifyingglass")
          .foregroundColor(.secondary)
          .padding(.leading, 24)
        
        TextField(LocalizedStrings.Search.searchBarPlaceholder.localized, text: Binding(
          get: { viewStore.searchText },
          set: { viewStore.send(.searchTextChanged($0)) }
        ))
        .textFieldStyle(PlainTextFieldStyle())
        .font(style.searchBarFont)
        .padding(.leading, 8)
        .disableAutocorrection(true)
        
        if !viewStore.searchText.isEmpty {
          Button {
            viewStore.send(.searchTextChanged(""))
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.secondary)
              .padding(.trailing, 24)
          }
          .transition(.opacity.combined(with: .scale))
          .animation(.easeInOut(duration: 0.2), value: viewStore.searchText)
        }
      }
      .padding(.horizontal, 8)
    }
  }
}

#Preview {
  SearchView(
    store: Store(
      initialState: SearchFeature.State(
        searchText: "Nature",
        photoList: [
          Photo(
            id: "preview1",
            altDescription: "Preview photo",
            urls: Urls(
              thumb: "https://picsum.photos/200/300",
              small: "https://picsum.photos/400/600",
              regular: "https://picsum.photos/800/1200",
              full: "https://picsum.photos/1200/1800"
            ),
            width: 4000,
            height: 3000,
            user: User(
              id: "user1",
              name: "Test User",
              username: "testuser"
            )
          )
        ]
      )
    ) {
      SearchFeature()
    }
  )
}
