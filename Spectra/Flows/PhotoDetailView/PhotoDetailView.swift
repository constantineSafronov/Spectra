//
//  PhotoDetailView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 18.10.2025.
//

import SwiftUI
import PhotosUI
import Kingfisher
import SwiftData
import ComposableArchitecture

struct PhotoDetailView: View {
  let store: StoreOf<PhotoDetailFeature>
  let namespace: Namespace.ID
  let dismissingThreshold = 150.0
  @Binding var isPresented: Bool
  
  @EnvironmentObject var style: StyleService
  
  init(
    store: StoreOf<PhotoDetailFeature>,
    namespace: Namespace.ID,
    isPresented: Binding<Bool>
  ) {
    self.store = store
    self.namespace = namespace
    self._isPresented = isPresented
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack(alignment: .topLeading) {
        Color.background
          .ignoresSafeArea()
        
        let imageView = Group {
          if viewStore.state.onDismiss {
            KFImage(URL(string: viewStore.photo.urls.small))
              .resizable()
              .scaledToFit()
              .matchedGeometryEffect(id: viewStore.photo.id, in: namespace)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .clipped()
          } else {
            KFImage(URL(string: viewStore.photo.urls.small))
              .resizable()
              .scaledToFit()
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .matchedGeometryEffect(id: viewStore.photo.id, in: namespace)
              .clipped()
          }
        }
          .offset(y: viewStore.dragOffset)
          .gesture(
            DragGesture()
              .onChanged { value in
                if value.translation.height > 0 {
                  viewStore.send(.dragChanged(value.translation.height))
                }
              }
              .onEnded { value in
                viewStore.send(.dragEnded(value.translation.height))
                if value.translation.height > dismissingThreshold {
                  DispatchQueue.main.async {
                    _ = withAnimation(.easeOut) {
                      viewStore.send(.dismissRequested)
                    }
                  }
                }
                else {
                  viewStore.send(.dragChanged(0))
                }
              }
          )
        
        imageView
        
        VStack {
          HStack {
            Spacer()
            Button {
              _ = withAnimation(.easeOut) {
                viewStore.send(.dismissRequested)
              }
            } label: {
              Image(systemName: "xmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.gray)
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
            }
            .padding()
          }
          Spacer()
          
          HStack(spacing: 20) {
            Button {
              viewStore.send(.saveToLibrary)
            } label: {
              Label(
                LocalizedStrings.Common.save.localized.capitalized,
                systemImage: viewStore.isSaving ? "arrow.down.circle.fill" : "square.and.arrow.down"
              )
              .font(style.controlsFont)
            }
            .disabled(viewStore.isSaving)
            
            Button {
              viewStore.send(.toggleFavorite)
            } label: {
              Label(
                LocalizedStrings.Common.favorite.localized.capitalized,
                systemImage: viewStore.isFavorite ? "heart.fill" : "heart"
              )
              .font(style.controlsFont)
            }
          }
          .padding(.vertical, 24)
          .foregroundColor(.accessory)
        }
      }
      .alert(
        viewStore.saveResultMessage ?? "",
        isPresented: viewStore.binding(
          get: \.showsSaveResult,
          send: .dismissSaveResult
        )
      ) {
        Button(LocalizedStrings.Common.ok.localized.uppercased(), role: .cancel) {}
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
      .onDisappear {
        viewStore.send(.dismissRequested)
      }
    }
  }
}
