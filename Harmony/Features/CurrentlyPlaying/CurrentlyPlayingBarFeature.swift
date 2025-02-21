//
//  CurrentlyPlayingBarFeature.swift
//  Harmony
//
//  Created by Ibrahim Kteish on 21/2/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct CurrentlyPlayingBarFeature {

  @ObservableState
  struct State {
    var trackName: String
    var artistName: String
    var isPlaying: Bool
    var albumArt: String
  }

  enum Action {
    case playButtonTapped
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in

      switch action {
        case .playButtonTapped:
          return .none
      }
    }
  }

}
