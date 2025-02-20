//
//  SearchResponse.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

struct SearchResponse: Codable {
  let results: [TrackResponse]
}

struct TrackResponse: Codable, Equatable, Sendable {
  let id: Int
  let img: String?
  let url: String?
  let trackName: String?
  let artistName: String?
  let collectionName: String?
  let infoURL: String?

  enum CodingKeys: String, CodingKey {
    case id = "trackId"
    case img = "artworkUrl100"
    case url = "previewUrl"
    case infoURL = "trackViewUrl"
    case trackName, artistName, collectionName
  }

  func toFavoriteTrack() -> FavoriteTrack {
    return FavoriteTrack(
      id: self.id,
      img: self.img,
      url: self.url,
      trackName: self.trackName,
      artistName: self.artistName,
      collectionName: self.collectionName,
      infoURL: self.infoURL
    )
  }
}
