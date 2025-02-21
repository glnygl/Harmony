//
//  FavoriteService.swift
//  Harmony
//
//  Created by Glny Gl on 13/02/2025.
//

import Foundation
import GRDB
import SharingGRDB

protocol FavoriteServiceProtocol: Sendable {
  func addFavorite(item: TrackResponse) async throws
  func deleteFavorite(item: TrackResponse) async throws
  func getFavorites(limit: Int, offset: Int) async throws -> [TrackResponse]
}

actor FavoriteService: FavoriteServiceProtocol {
  @Dependency(\.defaultDatabase) var dbQueue

  func addFavorite(item: TrackResponse) async throws {
    let favorite = item.toFavoriteTrack()
    try await dbQueue.write { db in
      try favorite.insert(db)
    }
  }

  func deleteFavorite(item: TrackResponse) async throws {
    try await dbQueue.write { db in
      _ = try FavoriteTrack
        .filter(Column("id") == Int64(item.id))
        .deleteAll(db)
    }
  }

  func getFavorites(limit: Int = 20, offset: Int = 0) async throws -> [TrackResponse] {
    try await dbQueue.read { db in
      let favorites = try FavoriteTrack
        .order(Column("id").desc)
        .limit(limit, offset: offset)
        .fetchAll(db)
      
      return favorites.map { $0.toTrackResponse() }
    }
  }
}
