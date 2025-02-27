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
    @Shared(.trackDuration)
    var duration: Double = 0.0
    @Shared(.trackCurrentTime)
    var currentTime: Double
    @Shared(.trackPlayStatus)
    var playStatus: PlayStatus = .once
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
        state.$currentTime.withLock { $0 = currentTime }
        let duration = musicPlayer.duration()
        if currentTime >= duration {
          let shouldPause = (state.playStatus == .once)
          if state.playStatus == .again {
            state.$playStatus.withLock { $0 = .once }
          }
          state.isPlaying = shouldPause
          return .run { send in
            await send(.seek(0))
            await send(.playButtonTapped)
            await send(.updateTime)
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

extension SharedKey where Self == InMemoryKey<Double>.Default {
  static var trackDuration: Self {
    Self[.inMemory("trackDuration"), default: 0]
  }
}

extension SharedKey where Self == InMemoryKey<Double>.Default {
  static var trackCurrentTime: Self {
    Self[.inMemory("trackCurrentTime"), default: 0]
  }
}
