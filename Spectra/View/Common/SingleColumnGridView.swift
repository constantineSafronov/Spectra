//
//  SingleColumnGridView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 20.10.2025.
//
import SwiftUI
import SwiftData
import Kingfisher
import PhotosUI

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
  
  @EnvironmentObject var style: StyleService
  @Environment(\.modelContext) private var modelContext
  
  @State private var showSaveResult = false
  @State private var saveResultMessage = ""
  @State private var isSaving: Bool = false
  
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
      VStack(spacing: 12.0) {
        Button {
          modelContext.delete(photo)
          try? modelContext.save()
        } label: {
          Image(systemName: "heart.fill")
            .foregroundColor(.white)
            .padding(8)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
        }
        
        Button {
          savePhotoToLibrary()
        } label: {
          Image(systemName: isSaving ? "arrow.down.circle.fill" : "square.and.arrow.down")
            .foregroundColor(.white)
            .padding(8)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
        }
        .disabled(isSaving)
      }.padding(10)
      
      
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
    .alert(saveResultMessage, isPresented: $showSaveResult) {
      Button("OK", role: .cancel) {}
    }
  }
  
  
  private func calculatedHeight(for photo: FavoritePhoto, width: CGFloat) -> CGFloat {
    let ratio = CGFloat(photo.height) / CGFloat(photo.width)
    
    return width * ratio
  }
  
  // MARK: - Save photo logic
  private func savePhotoToLibrary() {
    guard let url = URL(string: photo.fullURL) else { return }
    isSaving = true
    
    Task {
      do {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let image = UIImage(data: data) {
          await saveToPhotos(image)
          saveResultMessage = "Photo saved to your gallery"
        } else {
          saveResultMessage = "Failed to load image data"
        }
      } catch {
        saveResultMessage = "Error: \(error.localizedDescription)"
      }
      
      isSaving = false
      showSaveResult = true
    }
  }
  
  @MainActor
  private func saveToPhotos(_ image: UIImage) async {
    let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
    
    if status == .notDetermined {
      _ = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
    }
    
    await withCheckedContinuation { continuation in
      UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
      continuation.resume()
    }
  }
  
}
