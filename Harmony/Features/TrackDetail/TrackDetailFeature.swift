//
//  TrackDetailFeature.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import ComposableArchitecture

@Reducer
struct TrackDetailFeature {

  @ObservableState
  struct State: Equatable {
    var track: TrackResponse
    var musicURL: String?
    var isPlaying: Bool = false
    var currentTime: Double = 0
    var totalDuration: Double = 0
    var volume: Double = 0.5
  }

  enum Action {
    case setMusicURL(String)
    case playPauseTapped(Bool)
    case seek(Double)
    case updateVolume(Double)
    case updateTime(Double)
    case setInitialTime(Double, Double)
    case playerFinished
    case dismissButtonTapped
  }

  @Dependency(\.musicPlayer) var musicPlayer

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .setMusicURL(let url):
        state.musicURL = url
        return .run { send in
          do {
            try musicPlayer.setURL(url)
            await send(.setInitialTime(musicPlayer.currentTime(), musicPlayer.duration()))
          } catch {
            print(error)
          }
        }
      case .playPauseTapped(let isPlaying):
        state.isPlaying = isPlaying
        if isPlaying {
          musicPlayer.play()
        } else {
          musicPlayer.pause()
        }
        return .none
      case .updateVolume(let volume):
        state.volume = volume
        musicPlayer.setVolume(volume)
        return .none
      case .setInitialTime(let current, let duration):
        state.currentTime = current
        state.totalDuration = duration
        return .none
      case .seek(let current):
        state.currentTime = current
        musicPlayer.seek(to: current)
        return .none
      case let .updateTime(time):
        state.currentTime = time
        if time >= state.totalDuration {
          state.isPlaying = false
        }
        return .none
      default:
        return .none
      }
    }
  }
}
