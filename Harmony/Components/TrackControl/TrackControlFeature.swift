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
    @SharedReader(.fetch(Ids()))
    private var favoriteTrackIds: [Int64] = []
    var isFavorite: Bool {
      favoriteTrackIds.contains(Int64(trackId))
    }
    var isMute: Bool = false
    var playStatus: PlayStatus = .once

    init(trackId: Int) {
      self.trackId = trackId
    }
  }

  struct Ids: FetchKeyRequest {
    func fetch(_ db: GRDB.Database) throws -> [Int64] {
      try FavoriteTrack.all().fetchAll(db).map(\.id)
    }
  }

  enum Action {
    case infoButtonTapped
    case muteVolume(Bool)
    case setPlayStatus(PlayStatus)
    case favoriteButtonTapped(Bool)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .favoriteButtonTapped:
          return .none
      case .setPlayStatus(var status):
        status.next()
        state.playStatus = status
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
