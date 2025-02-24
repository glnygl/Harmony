//
//  CurrentlyPlayingFeature.swift
//  Harmony
//
//  Created by Ibrahim Kteish on 21/2/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct CurrentlyPlayingFeature {

  @Dependency(\.musicPlayer) var musicPlayer

  @ObservableState
  struct State: Equatable {
    var trackResponse: TrackResponse
    var isPlaying: Bool
  }

  enum Action: Equatable {
    case delegate(Delegate)
    case playButtonTapped
    case viewTapped
    case updateTime
    case seek(Double)

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
      case .updateTime:
        let currentTime = musicPlayer.currentTime()
        let duration = musicPlayer.duration()
        if currentTime >= duration {
          return .run { send in
            await send(.seek(0))
            await send(.playButtonTapped)
          }
        }
        return .none
      case .seek(let time):
        musicPlayer.seek(time)
        return .none
      }
    }
  }
}


