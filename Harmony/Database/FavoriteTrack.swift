//
//  FavoriteTrack.swift
//  Harmony
//
//  Created by Glny Gl on 12/02/2025.
//

import GRDB

struct FavoriteTrack: Codable, FetchableRecord, PersistableRecord, Sendable {
  static let databaseTableName = "favorites" // Define table name

  var id: Int64
  var img: String?
  var url: String?
  var trackName: String?
  var artistName: String?
  var collectionName: String?
  var infoURL: String?

  func toTrackResponse() -> TrackResponse {
    return TrackResponse(
      id: Int(self.id),
      img: self.img,
      url: self.url,
      trackName: self.trackName,
      artistName: self.artistName,
      collectionName: self.collectionName,
      infoURL: self.infoURL
    )
  }
}
