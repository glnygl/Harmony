//
//  TrackControlFeature.swift
//  Harmony
//
//  Created by Glny Gl on 11/02/2025.
//

import ComposableArchitecture

@Reducer
struct TrackControlFeature {

  @ObservableState
  struct State: Equatable {
    var isFavorite: Bool = false
    var isMute: Bool = false
    var playStatus: PlayStatus = .once
  }

  enum Action {
    case infoButtonTapped
    case muteVolume(Bool)
    case setPlayStatus(PlayStatus)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .setPlayStatus(var status):
        status.next()
        state.playStatus = status
        return .none
      default:
        return .none
      }
      }
    }
}
