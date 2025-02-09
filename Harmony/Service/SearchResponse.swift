//
//  SearchResponse.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

struct SearchResponse: Codable {
    let results: [TrackResponse]
}

struct TrackResponse: Codable, Equatable {
    let id: Int
    let img: String?
    let url: String?
    let trackName: String?
    let artistName: String?
    let collectionName: String?

  enum CodingKeys: String, CodingKey {
    case id = "trackId"
    case img = "artworkUrl100"
    case url = "previewUrl"
    case trackName, artistName, collectionName
  }
}
