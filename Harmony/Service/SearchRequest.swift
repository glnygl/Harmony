//
//  SearchRequest.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

import Foundation

struct SearchRequest: Request {
  var method: HTTPMethod = .get
  var path: String = "/search"
  var queryItems: [URLQueryItem]?

  init(searchText: String) {
    queryItems = SearchRequestQuery(term: searchText).toQueryItems()
  }
}

struct SearchRequestQuery: QueryParams, Encodable {
  let term: String
  let limit = 15
  let media = "music"
}
