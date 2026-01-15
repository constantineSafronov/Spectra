//
//  Photo.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import Foundation

struct SearchResponse: Codable, Equatable {
  let total: Int
  let totalPages: Int
  let results: [Photo]
  
  private enum CodingKeys: String, CodingKey {
    case total
    case totalPages = "total_pages"
    case results
  }
}
