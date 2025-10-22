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

struct PhotoDetailView: View {
  
  let photo: Photo
  let namespace: Namespace.ID
  
  private let dismissThreshold: CGFloat = 150
  @State private var onDisappear: Bool = false
  @State private var dragOffset: CGFloat = 0
  
  @Binding var isPresented: Bool
  @State private var isSaving = false
  @State private var showSaveResult = false
  @State private var saveResultMessage = ""
  
  @Environment(\.modelContext) private var modelContext
  @Query private var favorites: [FavoritePhoto]
  @EnvironmentObject var style: StyleService
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background
        .ignoresSafeArea()
      
      let imageView = Group {
        if onDisappear {
          KFImage(URL(string: photo.urls.small))
            .resizable()
            .scaledToFit()
            .matchedGeometryEffect(id: photo.id, in: namespace)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
        } else {
          KFImage(URL(string: photo.urls.small))
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .matchedGeometryEffect(id: photo.id, in: namespace)
        }
      }
      .offset(y: dragOffset)
      .gesture(
        DragGesture()
          .onChanged { value in
            if value.translation.height > 0 {
              dragOffset = value.translation.height
            }
          }
          .onEnded { value in
            if dragOffset > dismissThreshold {
              onDisappear = true
              withAnimation(.bouncy) {
                isPresented = false
              }
            } else {
              withAnimation(.spring()) {
                dragOffset = 0
              }
            }
          }
      )
      
      imageView
      
      VStack {
        HStack {
          Spacer()
          Button {
            onDisappear = true
            withAnimation(.bouncy) {
              isPresented = false
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
            savePhotoToLibrary()
          } label: {
            Label(
              LocalizedStrings.Common.save.localized.capitalized,
              systemImage: isSaving ? "arrow.down.circle.fill" : "square.and.arrow.down"
            )
              .font(style.controlsFont)
          }
          .disabled(isSaving)
          
          Button {
            if let favoritePhoto = favorites.first(where: { $0.id == photo.id }) {
              modelContext.delete(favoritePhoto)
            } else {
              modelContext.insert(FavoritePhoto(with: photo))
            }
            try? modelContext.save()
          } label: {
            Label("Favorite", systemImage: favorites.contains(where: { $0.id == photo.id }) ? "heart.fill" : "heart")
              .font(style.controlsFont)
          }
        }
        .padding(.vertical, 24)
        .foregroundColor(.accessory)
      }
    }
    .alert(saveResultMessage, isPresented: $showSaveResult) {
      Button(LocalizedStrings.Common.ok.localized.uppercased(), role: .cancel) {}
    }
    .onDisappear {
      isPresented = false
    }
  }
  
  // MARK: - Save photo logic
  private func savePhotoToLibrary() {
    guard let url = URL(string: photo.urls.full) else { return }
    isSaving = true
    
    Task {
      do {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let image = UIImage(data: data) {
          await saveToPhotos(image)
          saveResultMessage = LocalizedStrings.Common.savePhotoMessage.localized
        } else {
          saveResultMessage = LocalizedStrings.Common.savingPhotoFailureMessage.localized
        }
      } catch {
        saveResultMessage = "\(LocalizedStrings.Common.error.localized.capitalized): \(error.localizedDescription)"
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
