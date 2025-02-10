//
//  MusicService.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

protocol MusicServiceProtocol {
  func fetchSearchResponse(request: SearchRequest) async throws -> SearchResponse
  func fetchGenreResponse(request: GenreRequest) async throws -> SearchResponse 
}

final class MusicService: MusicServiceProtocol {

  private let network: NetworkProtocol

  init(network: NetworkProtocol = Network()) {
    self.network = network
  }

  func fetchSearchResponse(request: SearchRequest) async throws -> SearchResponse {
    return try await network.perform(request, responseType: SearchResponse.self)
  }

  func fetchGenreResponse(request: GenreRequest) async throws -> SearchResponse {
    return try await network.perform(request, responseType: SearchResponse.self)
  }
}
