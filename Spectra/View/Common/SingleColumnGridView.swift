//
//  SingleColumnGridView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 20.10.2025.
//
import SwiftUI
import SwiftData
import Kingfisher

struct SingleColumnGridView: View {
  
  @Query private var favorites: [FavoritePhoto]
  
  var body: some View {
    GeometryReader { geometry in
      let fullWidth = geometry.size.width
      
      ScrollView(.vertical) {
        VStack(spacing: 2) {
          ForEach(favorites, id: \.id) { photo in
            SingleColumnPhotoItemView(photo: photo, width: fullWidth)
          }
        }
      }
    }
  }
}

struct SingleColumnPhotoItemView: View {
  
  @AppStorage(AppStorageKeys.showAuthorName) private var showAuthorName: Bool = true
  @AppStorage(AppStorageKeys.showPhotoDescription) private var showDescription: Bool = true
  @EnvironmentObject var style: StyleService
  
  @Environment(\.modelContext) private var modelContext
  
  let photo: FavoritePhoto
  let width: CGFloat
  
  var body: some View {
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
      
      Button {
        modelContext.delete(photo)
        try? modelContext.save()
      } label: {
        Image(systemName: "heart.fill")
          .foregroundColor(.accessory)
          .padding(8)
          .background(.ultraThinMaterial)
          .clipShape(Circle())
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
        if showAuthorName {
          Text(photo.userName)
            .foregroundColor(.white)
            .font(style.titleFont)
            .shadow(radius: 2)
        }
        if let description = photo.photoDescription, showDescription {
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
  
  
  private func calculatedHeight(for photo: FavoritePhoto, width: CGFloat) -> CGFloat {
    let ratio = CGFloat(photo.height) / CGFloat(photo.width)
    
    return width * ratio
  }
  
}
