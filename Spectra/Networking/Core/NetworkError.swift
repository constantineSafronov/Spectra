//
//  NetworkError.swift
//  Spectra
//
//  Created by Konstantin Safronov on 20.10.2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
  case invalidResponse
  case invalidStatusCode(Int)
  case decodingError(Error)
  case transportError(Error)
  
  var errorDescription: String? {
    switch self {
    case .invalidResponse:
      return "Invalid server response"
      
    case .invalidStatusCode(let code):
      return "Server returned status code: \(code)"
      
    case .decodingError(let error):
      return "Decoding failed: \(error.localizedDescription)"
      
    case .transportError(let error):
      return "Transport error: \(error.localizedDescription)"
    }
  }
  
}
