//
//  GenreRequest.swift
//  Harmony
//
//  Created by Glny Gl on 10/02/2025.
//

import Foundation

struct GenreRequest: Request {
  var method: HTTPMethod = .get
  var path: String = "/search"
  var queryItems: [URLQueryItem]?

  init(genre: String) {
    queryItems = GenreRequestQuery(term: genre).toQueryItems()
  }
}

struct GenreRequestQuery: QueryParams, Encodable {
  let term: String
  let limit = 15
  let entity = "musicTrack"
}
