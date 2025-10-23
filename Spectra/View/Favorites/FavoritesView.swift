//
//  FavoritesView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 18.10.2025.
//

import SwiftUI
import SwiftData
import Kingfisher
import PhotosUI
import ComposableArchitecture

struct FavoritesView: View {
  @EnvironmentObject var style: StyleService
  let store: StoreOf<FavoritesFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      GeometryReader { geometry in
        ZStack(alignment: .topLeading) {
          Color.background.ignoresSafeArea()
          VStack(alignment: .leading) {
            Text(LocalizedStrings.Favorites.title.localized)
              .foregroundColor(.text)
              .font(style.largeTitleFont)
              .padding(.top, 20)
              .padding(.leading, 20)
            
            ScrollView {
              VStack(spacing: 2) {
                ForEach(viewStore.favorites, id: \.id) { photo in
                  FavoritesRowView(
                    photo: photo,
                    store: store,
                    screenWidth: geometry.size.width
                  )
                }
              }
            }
          }
        }
      }
      .onAppear { viewStore.send(.onAppear) }
      .alert("", isPresented: viewStore.binding(
        get: { $0.alert != nil },
        send: .dismissAlert
      )
      ) {
        Button(LocalizedStrings.Common.ok.localized.uppercased()) {
          viewStore.send(.dismissAlert)
        }
      } message: {
        if let alertMessage = viewStore.alert {
          Text(alertMessage)
        }
      }
    }
  }
}

struct FavoritesRowView: View {
  @EnvironmentObject var style: StyleService
  let photo: FavoritePhotoDTO
  let store: StoreOf<FavoritesFeature>
  let screenWidth: CGFloat
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      GeometryReader { geometry in
        let width = geometry.size.width
        ZStack(alignment: .topTrailing) {
          KFImage(URL(string: photo.smallURL))
            .placeholder {
              Color.gray.opacity(0.3)
                .frame(width: width, height: 150)
            }
            .resizable()
            .scaledToFill()
            .frame(width: width, height: calculatedHeight(for: photo, width: width))
            .clipped()
          
          VStack(spacing: 12) {
            Button {
              viewStore.send(.deletePhoto(photo))
            } label: {
              Image(systemName: "heart.fill")
                .foregroundColor(.white)
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
            }
            
            Button {
              viewStore.send(.saveToLibrary(photo))
            } label: {
              Image(systemName: viewStore.isSaving ? "arrow.down.circle.fill" : "square.and.arrow.down")
                .foregroundColor(.white)
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
            }
            .disabled(viewStore.isSaving)
          }
          .padding(10)
          
          LinearGradient(
            gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
            startPoint: .bottom,
            endPoint: .top
          )
          .frame(height: 120)
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
          .allowsHitTesting(false)
          
          VStack(alignment: .leading, spacing: 4) {
            if style.showAuthorName {
              Text(photo.userName)
                .foregroundColor(.white)
                .font(style.titleFont)
                .shadow(radius: 2)
            }
            if let description = photo.photoDescription, style.showDescription {
              Text(description.capitalized)
                .foregroundColor(.white)
                .font(style.descriptionFont)
                .lineLimit(2)
                .shadow(radius: 2)
            }
          }
          .padding(.horizontal, 12)
          .padding(.bottom, 12)
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
      }
      .frame(height: calculatedHeight(for: photo, width: screenWidth))
    }
  }
  
  private func calculatedHeight(for photo: FavoritePhotoDTO, width: CGFloat) -> CGFloat {
    let ratio = CGFloat(photo.height) / CGFloat(photo.width)
    return width * ratio
  }
  
}

// MARK: - Preview

#Preview("FavoritesView") {
  let store = Store(
    initialState: FavoritesFeature.State(),
    reducer: { FavoritesFeature() }
  )
  
  return FavoritesView(store: store)
}
