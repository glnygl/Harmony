//
//  PlayerControlFeature.swift
//  Harmony
//
//  Created by Glny Gl on 11/02/2025.
//

import ComposableArchitecture

@Reducer
struct PlayerControlFeature {

  @ObservableState
  struct State: Equatable {
    var isPlaying: Bool = false
  }
  
  enum Action {
    case playPauseTapped(Bool)
    case rewindTapped
    case forwardTapped
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .playPauseTapped(let shouldPlay):
        state.isPlaying = shouldPlay
        return .none
      case .rewindTapped:
        return .none
      case .forwardTapped:
        return .none
      }
    }
  }
}
