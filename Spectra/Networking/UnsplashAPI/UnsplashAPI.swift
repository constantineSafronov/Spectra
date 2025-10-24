//
//  UnsplashAPI.swift
//  Spectra
//
//  Created by Konstantin Safronov on 20.10.2025.
//

import Foundation

enum APIConfig {
    static let unsplashClientID = ""
}

extension URLRequest {
  init(unsplashPath: String, queryItems: [URLQueryItem] = []) {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.unsplash.com"
    components.path = "/\(unsplashPath)"
    components.queryItems = queryItems
    
    guard let url = components.url else {
      fatalError("Invalid URL components")
    }
    
    self.init(url: url)
    self.httpMethod = "GET"
    self.addValue("Client-ID \(APIConfig.unsplashClientID)", forHTTPHeaderField: "Authorization")
  }
  
}

enum UnsplashAPI {
  static func feed(
    category: String,
    page: Int,
    perPage: Int = 30
  ) -> Resource<SearchResponse> {
    let request = URLRequest(
      unsplashPath: "search/photos",
      queryItems: [
        URLQueryItem(name: "query", value: category),
        URLQueryItem(name: "page", value: "\(page)"),
        URLQueryItem(name: "per_page", value: "\(perPage)")
      ]
    )
    return Resource(
      urlRequest: request,
      serializer: Resource<SearchResponse>.jsonSerializer()
    )
  }
  
}
