//
//  SearchView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import SwiftUI

import SwiftUI

struct SearchView: View {
  
  @ObservedObject var model: SearchModel
  @Namespace private var animationNamespace
  @State private var showDetail = false
  @State private var selectedPhoto: Photo?
  @EnvironmentObject var style: StyleService
  
  init(model: SearchModel) {
    self.model = model
  }
  
  var body: some View {
    ZStack {
      NavigationView {
        ZStack {
          Color(.background)
            .ignoresSafeArea()
          
          VStack(spacing: 0) {
            searchBar()
              .padding(.top, 8)
            
            MasonryGridView(
              photos: $model.photoList,
              isLoadingNeeded: $model.isLoadingNeeded,
              animationNamespace: animationNamespace,
              onPhotoTap: { photo in
                withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
                  selectedPhoto = photo
                  showDetail = true
                }
              }
            )
            .padding(.top, 20.0)
          }
        }
        .navigationBarHidden(true)
      }
      .zIndex(0)
      
      if let photo = selectedPhoto, showDetail {
        PhotoDetailView(
          photo: photo,
          namespace: animationNamespace,
          isPresented: $showDetail
        )
        .zIndex(1)
        .transition(.opacity)
      }
    }
    .alert(model.localizedError, isPresented: $model.showsError) {
      Button("OK", role: .cancel) {}
    }
  }
  
  private func searchBar() -> some View {
    ZStack {
      VisualEffectBlur(blurStyle: .systemMaterial)
        .frame(height: 56)
        .cornerRadius(23)
        .padding(.horizontal)
      HStack {
        Image(systemName: "magnifyingglass")
          .foregroundColor(.secondary)
          .padding(.leading, 16)
        TextField("Search photos", text: $model.searchText)
          .textFieldStyle(PlainTextFieldStyle())
          .font(style.searchBarFont)
          .padding(.leading, 16)
      }
      .padding(.horizontal, 16)
    }
  }
  
}

// MARK: - Preview
struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView(model: SearchModel())
  }
  
}
