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

  @Dependency(\.musicPlayer) var musicPlayer

  @ObservableState
  struct State: Equatable {
    var trackName: String
    var artistName: String
    var isPlaying: Bool
    var albumArt: String
  }

  enum Action: Equatable {
    case playButtonTapped
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        case .playButtonTapped:
          let isPlaying = state.isPlaying
          state.isPlaying.toggle()
          return .run { _ in
            isPlaying ? self.musicPlayer.pause() : self.musicPlayer.play()
          }
      }
    }
  }
}


