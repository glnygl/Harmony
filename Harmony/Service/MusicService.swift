//
//  MusicService.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

import Foundation

struct MusicService {
  var fetchSearchResponse: @Sendable (SearchRequest) async throws -> SearchResponse
  var fetchGenreResponse: @Sendable (GenreRequest) async throws -> SearchResponse
}

extension MusicService {
  static func live(network: NetworkService) -> MusicService {
    MusicService(
      fetchSearchResponse: { request in
        let data = try await network.perform(request)
        return try JSONDecoder().decode(SearchResponse.self, from: data)
      },
      fetchGenreResponse: { request in
        let data = try await network.perform(request)
        return try JSONDecoder().decode(SearchResponse.self, from: data)
      }
    )
  }
}
