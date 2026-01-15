//
//  UnsplashClient.swift
//  Spectra
//
//  Created by Konstantin Safronov on 24.10.2025.
//

import Foundation
import ComposableArchitecture

struct UnsplashClient {
  var search: @Sendable (String, Int) async throws -> SearchResponse
}

extension DependencyValues {
  var unsplashClient: UnsplashClient {
    get { self[UnsplashClient.self] }
    set { self[UnsplashClient.self] = newValue }
  }
}

extension UnsplashClient: DependencyKey {
  static let liveValue = UnsplashClient(
    search: { query, page in
      let api = await UnsplashAPI.feed(category: query, page: page)
      do {
        return try await URLSession.shared.data(from: api)
      } catch {
        throw NetworkError.transportError(error)
      }
    }
  )
}
