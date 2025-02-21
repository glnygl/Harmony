//
//  DependencyKeys.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

import AVFoundation
import Dependencies
import SharingGRDB

extension DependencyValues {

  var networkService: NetworkService {
    get { self[NetworkServiceKey.self] }
    set { self[NetworkServiceKey.self] = newValue }
  }

  var musicService: MusicService {
    get { self[MusicServiceKey.self] }
    set { self[MusicServiceKey.self] = newValue }
  }

  var musicPlayer: MusicPlayerService {
    get { self[MusicPlayerKey.self] }
    set { self[MusicPlayerKey.self] = newValue }
  }

  var favoriteService: FavoriteService {
    get { self[FavoriteServiceKey.self] }
    set { self[FavoriteServiceKey.self] = newValue }
  }
}

private enum NetworkServiceKey: DependencyKey {
  static let liveValue: NetworkService = .liveValue
}

private enum MusicServiceKey: DependencyKey {
  static let liveValue: MusicService = .liveValue
}

private enum MusicPlayerKey: DependencyKey {
  static let liveValue: MusicPlayerService = .liveValue
}

private enum FavoriteServiceKey: DependencyKey {
  static var liveValue: FavoriteService {
    @Dependency(\.defaultDatabase) var dbQueue

    return FavoriteService(
      addFavorite: { item in
        let favorite = item.toFavoriteTrack()
        try await dbQueue.write { db in
          try favorite.insert(db)
        }
      },
      deleteFavorite: { item in
        try await dbQueue.write { db in
          _ = try FavoriteTrack
            .filter(Column("id") == item.id)
            .deleteAll(db)
        }
      },
      getFavorites: { limit, offset in
        try await dbQueue.read { db in
          let favorites = try FavoriteTrack
            .order(Column("id").desc)
            .limit(limit, offset: offset)
            .fetchAll(db)
          return favorites.map { $0.toTrackResponse() }
        }
      }
    )
  }
}
