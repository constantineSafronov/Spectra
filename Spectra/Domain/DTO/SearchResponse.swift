//
//  Photo.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import Foundation

struct Photo: Codable, Equatable, Identifiable, Hashable {
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
}

struct Urls: Codable, Equatable, Hashable {
  let thumb: String
  let small: String
  let regular: String
  let full: String
}

struct User: Codable, Equatable, Hashable {
  let id: String
  let name: String
  let username: String
}

struct SearchResponse: Codable, Equatable {
  let total: Int
  let totalPages: Int
  let results: [Photo]
  
  enum CodingKeys: String, CodingKey {
    case total
    case totalPages = "total_pages"
    case results
  }
}
