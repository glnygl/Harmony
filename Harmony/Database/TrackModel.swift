//
//  TrackModel.swift
//  Harmony
//
//  Created by Glny Gl on 12/02/2025.
//

import SwiftData

@Model
final class TrackModel {
  @Attribute(.unique) var id: Int
  var img: String?
  var url: String?
  var trackName: String?
  var artistName: String?
  var collectionName: String?
  var infoURL: String?

  init(id: Int, img: String? = nil, url: String? = nil, trackName: String? = nil, artistName: String? = nil, collectionName: String? = nil, infoURL: String? = nil) {
    self.id = id
    self.img = img
    self.url = url
    self.trackName = trackName
    self.artistName = artistName
    self.collectionName = collectionName
    self.infoURL = infoURL
  }
}
