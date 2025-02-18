//
//  Network.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

import Foundation

struct NetworkService {
  var perform: @Sendable (Request) async throws -> Data
}

extension NetworkService {

  static let liveValue = NetworkService(perform: { request in
    let urlSession = URLSession.shared
    let (data, response) = try await urlSession.data(for: request.asURLRequest())

    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
      throw NetworkError.invalidResponse
    }
    return data
  })
}
