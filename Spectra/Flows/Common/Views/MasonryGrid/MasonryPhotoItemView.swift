//
//  MasonryPhotoItemView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 01.11.2025.
//

import SwiftUI
import Kingfisher

struct MasonryPhotoItemView: View {
  let photo: Photo
  let width: CGFloat
  let namespace: Namespace.ID
  
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
        if style.showAuthorName {
          Text(photo.user.name)
            .foregroundColor(.white)
            .font(style.titleFont)
            .shadow(radius: 2)
        }
        if let description = photo.altDescription, style.showDescription {
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
