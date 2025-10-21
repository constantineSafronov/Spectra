//
//  Resource.swift
//  Spectra
//
//  Created by Konstantin Safronov on 20.10.2025.
//

import Foundation

public struct Resource<T>: Sendable {
  let urlRequest: URLRequest
  let serializer: @Sendable (URLResponse, Data) throws -> T
  
}

extension Resource where T: Decodable {
  public static func jsonSerializer() -> @Sendable (URLResponse, Data) throws -> T {
    { response, data in
      let decoder = JSONDecoder()
      let value = try decoder.decode(T.self, from: data)
      
      return value
    }
  }
  
}
