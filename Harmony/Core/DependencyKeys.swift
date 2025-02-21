//
//  DependencyKeys.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

import Dependencies
import AVFoundation

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

  var favoriteService: FavoriteServiceProtocol {
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
  static var liveValue: FavoriteServiceProtocol {
        return FavoriteService()
  }
}
