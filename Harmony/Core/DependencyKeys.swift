//
//  DependencyKeys.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

import Dependencies
import AVFoundation
import SwiftData

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
  static let liveValue: NetworkService = .live
}

private enum MusicServiceKey: DependencyKey {
  static let liveValue: MusicService = .live(network: .live)
}

private enum MusicPlayerKey: DependencyKey {
  static let liveValue: MusicPlayerService = .live(player: AVPlayer())
}

private enum FavoriteServiceKey: DependencyKey {
  static var liveValue: FavoriteServiceProtocol {
    do {
      let config = ModelConfiguration(for: FavoriteTrack.self)
      let container = try ModelContainer(for: FavoriteTrack.self, configurations: config)
      let context = ModelContext(container)
      return FavoriteService(context: context)
    } catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }
  }
}
