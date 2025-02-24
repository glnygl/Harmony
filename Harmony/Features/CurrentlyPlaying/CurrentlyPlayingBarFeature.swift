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
    var trackResponse: TrackResponse
    var isPlaying: Bool

    var trackName: String {
      self.trackResponse.trackName!
    }
    var artistName: String {
      self.trackResponse.artistName!
    }
    var albumArt: String {
      self.trackResponse.img!
    }
  }

  enum Action: Equatable {
    case delegate(Delegate)
    case playButtonTapped
    case viewTapped

    enum Delegate: Equatable {
      case tapped(TrackResponse)
    }
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        case .delegate:
          return .none
        case .playButtonTapped:
          let isPlaying = state.isPlaying
          state.isPlaying.toggle()
          return .run { _ in
            isPlaying ? self.musicPlayer.pause() : self.musicPlayer.play()
          }
        case .viewTapped:
          return .send(.delegate(.tapped(state.trackResponse)))
      }
    }
  }
}


