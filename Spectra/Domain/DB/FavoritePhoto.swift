//
//  FavoritePhoto.swift
//  Spectra
//
//  Created by Konstantin Safronov on 18.10.2025.
//

import SwiftData

@Model
final class FavoritePhoto {
  @Attribute(.unique) var id: String
  @Attribute var userName: String
  @Attribute var photoDescription: String?
  @Attribute var smallURL: String
  @Attribute var fullURL: String
  @Attribute var width: Float
  @Attribute var height: Float
  
  init(
    id: String,
    userName: String,
    photoDescription: String? = nil,
    smallURL: String,
    fullURL: String,
    width: Float,
    height: Float) {
    self.id = id
    self.userName = userName
    self.photoDescription = photoDescription
    self.smallURL = smallURL
    self.fullURL = fullURL
    self.width = width
    self.height = height
  }
  
  init(with photo: Photo) {
    self.id = photo.id
    self.userName = photo.user.name
    self.photoDescription = photo.altDescription
    self.smallURL = photo.urls.small
    self.fullURL = photo.urls.full
    self.width = photo.width
    self.height = photo.height
  }
  
}
