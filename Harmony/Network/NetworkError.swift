//
//  NetworkError.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

import Foundation

enum NetworkError: LocalizedError {
  case invalidURL
  case invalidResponse
  case jsonEncodeError

  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "The URL is invalid"
    case .invalidResponse:
      return "Invalid response received from server"
    case .jsonEncodeError:
      return "Failed to encode JSON data"
    }
  }
}
