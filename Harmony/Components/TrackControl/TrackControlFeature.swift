//
//  TrackControlFeature.swift
//  Harmony
//
//  Created by Glny Gl on 11/02/2025.
//

import ComposableArchitecture
import SharingGRDB

@Reducer
struct TrackControlFeature {

  @ObservableState
  struct State: Equatable {
    var trackId: Int
    @SharedReader
    var isFavorite: Bool
    var isMute: Bool = false
    @Shared(.inMemory("playStatus"))
    var playStatus: PlayStatus = .once

    init(trackId: Int) {
      self.trackId = trackId
      _isFavorite = SharedReader(wrappedValue: false, .fetch(Exists(trackId: Int64(trackId))))
    }
  }

  struct Exists: FetchKeyRequest {
    let trackId: Int64
    func fetch(_ db: GRDB.Database) throws -> Bool {
      try FavoriteTrack.filter(Column("id") == trackId).fetchCount(db) > 0
    }
  }

  enum Action {
    case infoButtonTapped
    case muteVolume(Bool)
    case setPlayStatus
    case favoriteButtonTapped(Bool)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        case .favoriteButtonTapped:
          return .none
        case .setPlayStatus:
          let new = state.playStatus.next()
          state.$playStatus.withLock { $0 = new }
          return .none
        case .muteVolume(let value):
          state.isMute = value
          return .none
        case .infoButtonTapped:
          return .none
      }
    }
  }
}
