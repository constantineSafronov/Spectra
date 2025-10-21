//
//  MassonaryGridView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import SwiftUI
import Kingfisher

struct MasonryGridView: View {
  private let loadingTriggerArea: CGFloat = 100
  
  @Binding var photos: [Photo]
  @Binding var isLoadingNeeded: Bool
  @EnvironmentObject var style: StyleService
  
  var animationNamespace: Namespace.ID
  var onPhotoTap: (Photo) -> Void
  
  var body: some View {
    GeometryReader { geometry in
      let columnWidth = (geometry.size.width - 2) / 2
      
      ScrollView(.vertical) {
        HStack(alignment: .top, spacing: 2) {
          VStack(spacing: 2) {
            ForEach(leftColumn(columnWidth: columnWidth), id: \.id) { photo in
              MasonryPhotoItemView(
                photo: photo,
                width: columnWidth,
                namespace: animationNamespace
              )
              .onTapGesture { onPhotoTap(photo) }
            }
          }
          VStack(spacing: 2) {
            ForEach(rightColumn(columnWidth: columnWidth), id: \.id) { photo in
              MasonryPhotoItemView(
                photo: photo,
                width: columnWidth,
                namespace: animationNamespace
              )
              .onTapGesture { onPhotoTap(photo) }
            }
          }
        }
        Text("Fetching ...")
          .foregroundColor(.text)
          .font(style.titleFont)
          .padding(.top, 12)
          .background(
            GeometryReader { geo in
              Color.clear
                .preference(
                  key: ScrollOffsetKey.self,
                  value: geo.frame(in: .global).minY)
            }
          )
          .onPreferenceChange(ScrollOffsetKey.self) { minY in
            let screenHeight = geometry.frame(in: .global).height
            if minY < screenHeight + loadingTriggerArea, !isLoadingNeeded {
              isLoadingNeeded = true
            }
          }
          .opacity(photos.isEmpty ? 0 : 1)
      }
    }
  }
  
  // MARK: - Masonry logic
  
  private func leftColumn(columnWidth: CGFloat) -> [Photo] {
    distributePhotos(columnWidth: columnWidth).0
  }
  
  private func rightColumn(columnWidth: CGFloat) -> [Photo] {
    distributePhotos(columnWidth: columnWidth).1
  }
  
  private func distributePhotos(columnWidth: CGFloat) -> ([Photo], [Photo]) {
    var left: [Photo] = []
    var right: [Photo] = []
    var leftHeight: CGFloat = 0
    var rightHeight: CGFloat = 0
    
    for photo in photos {
      let photoHeight = calculatedHeight(for: photo, width: columnWidth)
      if leftHeight <= rightHeight {
        left.append(photo)
        leftHeight += photoHeight + 2
      } else {
        right.append(photo)
        rightHeight += photoHeight + 2
      }
    }
    
    return (left, right)
  }
  
  private func calculatedHeight(for photo: Photo, width: CGFloat) -> CGFloat {
    let ratio = CGFloat(photo.height) / CGFloat(photo.width)
    return width * ratio
  }
  
}

private struct ScrollOffsetKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
  
}

struct MasonryPhotoItemView: View {
  let photo: Photo
  let width: CGFloat
  let namespace: Namespace.ID
  
  @AppStorage(AppStorageKeys.showAuthorName) private var showAuthorName: Bool = true
  @AppStorage(AppStorageKeys.showPhotoDescription) private var showDescription: Bool = true
  @EnvironmentObject var style: StyleService
  
  var body: some View {
    ZStack(alignment: .bottomLeading) {
      KFImage(URL(string: photo.urls.small))
        .placeholder {
          Color.gray.opacity(0.3)
            .frame(width: width, height: 150)
        }
        .resizable()
        .scaledToFit()
      
        .matchedGeometryEffect(id: photo.id, in: namespace)
        .frame(width: width, height: calculatedHeight(for: photo, width: width))
        .clipped()
      
      LinearGradient(
        gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
        startPoint: .bottom,
        endPoint: .top
      )
      .frame(height: 120)
      .frame(maxWidth: .infinity, alignment: .bottom)
      .clipped()
      .allowsHitTesting(false)
      
      VStack(alignment: .leading, spacing: 4) {
        if showAuthorName {
          Text(photo.user.name)
            .foregroundColor(.white)
            .font(style.titleFont)
            .shadow(radius: 2)
        }
        if let description = photo.altDescription, showDescription {
          Text(description.capitalized)
            .foregroundColor(.white)
            .font(style.descriptionFont)
            .lineLimit(2)
            .shadow(radius: 2)
        }
      }
      .padding(.horizontal, 12)
      .padding(.bottom, 12)
    }
  }
  
  private func calculatedHeight(for photo: Photo, width: CGFloat) -> CGFloat {
    let ratio = CGFloat(photo.height) / CGFloat(photo.width)
    
    return width * ratio
  }
  
}
