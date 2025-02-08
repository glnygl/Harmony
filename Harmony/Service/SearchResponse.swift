//
//  SearchResponse.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

struct SearchResponse: Codable {
    let results: [TracksResponse]
}

struct TracksResponse: Codable {
    let trackName: String?
    let artworkUrl100: String?
    let collectionName: String?
    let artistName: String?
    var previewUrl: String?
}
