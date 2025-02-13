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
