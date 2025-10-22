//
//  Photo.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import Foundation

struct SearchResponse: Codable {
  let total: Int
  let totalPages: Int
  let results: [Photo]
  
  enum CodingKeys: String, CodingKey {
    case total
    case totalPages = "total_pages"
    case results
  }
  
}

struct Collection: Codable {
  let id: String
  let title: String
  let description: String?
  let totalPhotos: Int
  let coverPhoto: Photo
  let user: User
  
  enum CodingKeys: String, CodingKey {
    case id, title, description, user
    case totalPhotos = "total_photos"
    case coverPhoto = "cover_photo"
  }
  
}

struct Photo: Codable, Equatable {
  let id: String
  let altDescription: String?
  let urls: Urls
  let width: Float
  let height: Float
  let user: User
  
  enum CodingKeys: String, CodingKey {
    case id
    case altDescription = "alt_description"
    case urls
    case width
    case height
    case user
  }
  
  static func == (lhs: Photo, rhs: Photo) -> Bool {
    lhs.id == rhs.id
  }
  
}

struct Urls: Codable {
  let thumb: String
  let small: String
  let regular: String
  let full: String
  
}

struct User: Codable {
  let id: String
  let name: String
  let username: String
  
}
