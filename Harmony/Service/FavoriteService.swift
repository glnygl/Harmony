//
//  FavoriteService.swift
//  Harmony
//
//  Created by Glny Gl on 13/02/2025.
//

import SwiftData
import Foundation

protocol FavoriteServiceProtocol {
  func addFavorite(item: TrackResponse) throws
  func deleteFavorite(item: TrackResponse) throws
  func getFavorites(limit: Int, offset: Int) throws -> [TrackResponse]
  func isFavorite(trackID: Int) -> Bool
}

final class FavoriteService: FavoriteServiceProtocol {
  private let context: ModelContext
  private var favoriteIDs: Set<Int> = []

  init(context: ModelContext) {
    self.context = context
    loadFavorites()
  }

  func addFavorite(item: TrackResponse) throws {
    if isFavorite(trackID: item.id) { return }
    context.insert(item.toFavoriteTrack())
    try context.save()
    favoriteIDs.insert(item.id)
  }

  func deleteFavorite(item: TrackResponse) throws {
    let descriptor = FetchDescriptor<FavoriteTrack>(
      predicate: #Predicate { $0.id == item.id }
    )
    if let favoriteTrack = try context.fetch(descriptor).first {
      context.delete(favoriteTrack)
      try context.save()
      favoriteIDs.remove(item.id)
    }
  }

  func getFavorites(limit: Int = 20, offset: Int = 0) throws -> [TrackResponse] {
    var descriptor = FetchDescriptor<FavoriteTrack>()
    descriptor.fetchLimit = limit
    descriptor.fetchOffset = offset
    let favoriteItems = try context.fetch(descriptor)
    return favoriteItems.map { $0.toTrackResponse() }
  }

  private func loadFavorites() {
    var descriptor = FetchDescriptor<FavoriteTrack>()
    descriptor.propertiesToFetch = [\.id]

    if let items = try? context.fetch(descriptor) {
      self.favoriteIDs = Set(items.map { $0.id })
    }
  }

  func isFavorite(trackID: Int) -> Bool {
    favoriteIDs.contains(trackID)
  }
}
