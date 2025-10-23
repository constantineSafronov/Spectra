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
  @ObservedObject var model: FeedModel
  private let modelContext: ModelContext
  @Namespace private var animationNamespace
  @State private var selectedPhoto: Photo?
  @State private var showDetail = false
  
  init(model: FeedModel, modelContext: ModelContext) {
    self.modelContext = modelContext
    self.model = model
  }
  
  var body: some View {
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
          .padding(.top, 34.0)
        }
        .frame(height: 100.0)
        .ignoresSafeArea()
        CategoryPicker(
          selectedCategory: $model.selectedCategory
        )
        MasonryGridView(
          photos: $model.photoList,
          isLoadingNeeded: $model.isLoadingNeeded,
          animationNamespace: animationNamespace,
          onPhotoTap: { photo in
            selectedPhoto = photo
            withAnimation(.bouncy) {
              showDetail = true
            }
          }
        )
      }
      .ignoresSafeArea()
      .zIndex(0)
      if model.isLoadingNeeded && model.photoList.isEmpty {
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
      if let photo = selectedPhoto, showDetail {
        PhotoDetailView(
          photo: photo,
          namespace: animationNamespace,
          modelContext: modelContext,
          isPresented: $showDetail
        )
        .zIndex(1)
      }
    }
    .alert(model.localizedError, isPresented: $model.showsError) {
      Button(LocalizedStrings.Common.ok.localized.uppercased(), role: .cancel) {}
    }
  }
}

// MARK: - Preview

#Preview {
  let mockModel = FeedModel()
  let mockContainer = try! ModelContainer(for: FavoritePhoto.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
  let mockContext = mockContainer.mainContext
  
  FeedView(
    model: mockModel,
    modelContext: mockContext
  )
}
