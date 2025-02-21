//
//  FavoriteService.swift
//  Harmony
//
//  Created by Glny Gl on 13/02/2025.
//

import Foundation
import GRDB
import SharingGRDB
import Dependencies
import DependenciesMacros


struct FavoriteService {
  var addFavorite: @Sendable (TrackResponse)  async throws -> Void
  var deleteFavorite: @Sendable (TrackResponse) async throws -> Void
  var getFavorites: @Sendable (Int, Int) async throws -> [TrackResponse]

  init(
    addFavorite: @Sendable @escaping (TrackResponse)  async throws -> Void,
    deleteFavorite: @Sendable @escaping (TrackResponse)  async throws-> Void,
    getFavorites: @Sendable @escaping (Int, Int)  async  throws-> [TrackResponse]
  ) {
    self.addFavorite = addFavorite
    self.deleteFavorite = deleteFavorite
    self.getFavorites = getFavorites
  }
}
