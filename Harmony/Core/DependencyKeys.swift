//
//  DependencyKeys.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

import Dependencies

extension DependencyValues {
  var musicService: MusicServiceProtocol {
    get { self[MusicServiceKey.self] }
    set { self[MusicServiceKey.self] = newValue }
  }

  var musicPlayer: MusicPlayerProtocol {
    get { self[MusicPlayerKey.self] }
    set { self[MusicPlayerKey.self] = newValue }
  }
}

private enum MusicServiceKey: DependencyKey {
  static let liveValue: MusicServiceProtocol = MusicService()
}

private enum MusicPlayerKey: DependencyKey {
  static let liveValue: MusicPlayerProtocol = MusicPlayerService()
}
