//
//  FeedView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import SwiftUI
import UIKit

struct FeedView: View {
  @ObservedObject var model: FeedModel
  
  @Namespace private var animationNamespace
  @State private var selectedPhoto: Photo?
  @State private var showDetail = false
  
  init(model: FeedModel) {
    self.model = model
  }
  
  var body: some View {
    ZStack {
      Color.background
        .ignoresSafeArea()
      VStack {
        CategoryPicker(
          selectedCategory: $model.selectedCategory
        )
        .padding(.horizontal, 16)
        .padding(.top, 6)
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
        .padding(.top, 12.0)
      }
      .zIndex(0)
      if let photo = selectedPhoto, showDetail {
        PhotoDetailView(
          photo: photo,
          namespace: animationNamespace,
          isPresented: $showDetail
        )
        .zIndex(1)
      }
    }
    .alert(model.localizedError, isPresented: $model.showsError) {
      Button("OK", role: .cancel) {}
    }
  }
}

#Preview {
  FeedView(model: FeedModel())
}


