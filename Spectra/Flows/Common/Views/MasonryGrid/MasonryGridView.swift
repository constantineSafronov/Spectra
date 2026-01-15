//
//  MassonaryGridView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import SwiftUI

struct MasonryGridView: View {
  private let loadingTriggerArea: CGFloat = 100
  
  let photos: [Photo]
  let isLoading: Bool
  @EnvironmentObject var style: StyleService
  
  var animationNamespace: Namespace.ID
  var onPhotoTap: (Photo) -> Void
  var onLoadMore: () -> Void
  
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
        
        if !photos.isEmpty {
          Text(LocalizedStrings.Common.fetching.localized)
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
              if minY < screenHeight + loadingTriggerArea, !isLoading {
                onLoadMore()
              }
            }
        }
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
