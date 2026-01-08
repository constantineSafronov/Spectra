//
//  Photo.swift
//  Spectra
//
//  Created by Konstantin Safronov on 08.01.2026.
//

import Foundation

struct Photo: Codable, Equatable, Identifiable, Hashable {
  let id: String
  let altDescription: String?
  let urls: Urls
  let width: Float
  let height: Float
  let user: User
  
  private enum CodingKeys: String, CodingKey {
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
