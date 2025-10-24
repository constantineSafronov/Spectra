//
//  FeedView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import SwiftUI
import UIKit
import SwiftData
import ComposableArchitecture

struct FeedView: View {
  let store: StoreOf<FeedFeature>
  private let modelContext: ModelContext
  @Namespace private var animationNamespace
  @EnvironmentObject var style: StyleService
  
  init(store: StoreOf<FeedFeature>, modelContext: ModelContext) {
    self.store = store
    self.modelContext = modelContext
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack {
        Color.background
          .ignoresSafeArea()
        
        VStack {
          ZStack {
            Color.logoBackground
            HStack(alignment: .center) {
              Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(width: 40.0, height: 40.0)
                .clipped()
              Text(LocalizedStrings.Common.appName.localized)
                .font(.title)
                .foregroundColor(.black)
            }
            .padding(.top, 36.0)
          }
          .frame(height: 100.0)
          .ignoresSafeArea()
          
          CategoryPicker(
            selectedCategory: Binding(
              get: { viewStore.selectedCategory },
              set: { viewStore.send(.categorySelected($0)) }
            )
          )
          .padding(.leading, 8.0)
          
          MasonryGridView(
            photos: viewStore.photoList,
            isLoading: viewStore.isLoading,
            animationNamespace: animationNamespace,
            onPhotoTap: { photo in
              let binding = Binding(
                get: { viewStore.selectedPhoto },
                set: { newValue in
                  withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
                    if let newValue = newValue {
                      viewStore.send(.photoSelected(newValue))
                    }
                  }
                }
              )
              binding.wrappedValue = photo
            },
            onLoadMore: {
              viewStore.send(.loadMore)
            }
          )
        }
        .ignoresSafeArea()
        .zIndex(0)
        
        if viewStore.isLoading && viewStore.photoList.isEmpty {
          ProgressView()
            .scaleEffect(1.5)
            .tint(.white)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.3))
            )
            .transition(.opacity)
            .zIndex(2)
        }
        
        if let photo = viewStore.selectedPhoto, viewStore.showDetail {
            PhotoDetailView(
                store: Store(
                    initialState: PhotoDetailFeature.State(photo: photo)
                ) {
                    PhotoDetailFeature()
                    .dependency(\.photoDetailClient, PhotoDetailClient.live(context: modelContext))
                    .dependency(\.photoLibraryClient, PhotoLibraryClient.live())
                },
                namespace: animationNamespace,
                isPresented: Binding(
                    get: { viewStore.showDetail },
                    set: { if !$0 { viewStore.send(.detailDismissed) } }
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
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
  
}

#Preview {
  let modelContext = try! ModelContainer(
    for: Schema([]),
    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
  ).mainContext
  
  FeedView(
    store: Store(
      initialState: FeedFeature.State(
        selectedCategory: .nature,
        photoList: [
          Photo(
            id: "preview1",
            altDescription: "Beautiful nature",
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
              name: "Nature Lover",
              username: "naturephotographer"
            )
          ),
          Photo(
            id: "preview2",
            altDescription: "Mountain landscape",
            urls: Urls(
              thumb: "https://picsum.photos/200/300",
              small: "https://picsum.photos/400/600",
              regular: "https://picsum.photos/800/1200",
              full: "https://picsum.photos/1200/1800"
            ),
            width: 5000,
            height: 3333,
            user: User(
              id: "user2",
              name: "Mountain Explorer",
              username: "mountainview"
            )
          )
        ]
      )
    ) {
      FeedFeature()
    },
    modelContext: modelContext
  )
}
