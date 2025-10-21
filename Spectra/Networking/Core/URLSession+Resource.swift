//
//  URLSession+Resource.swift
//  Spectra
//
//  Created by Konstantin Safronov on 20.10.2025.
//

import Foundation

public extension URLSession {
  func data<T>(from resource: Resource<T>) async throws -> T {
    do {
      let (data, response) = try await data(for: resource.urlRequest)
      
      return try resource.serializer(response, data)
    } catch let error as NetworkError {
      throw error
    } catch {
      throw NetworkError.transportError(error)
    }
  }
  
}
