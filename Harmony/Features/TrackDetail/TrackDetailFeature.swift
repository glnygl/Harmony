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
    case setTime(Double, Double)
    case playerFinished
    case startTimer
    case invalidateTimer
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
            try musicPlayer.setMusicURL(url)
            await send(.setTime(musicPlayer.currentTime(), musicPlayer.duration()))
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
      case .setTime(let current, let duration):
        state.currentTime = current
        state.totalDuration = duration
        return .none
      case .seek(let current):
         musicPlayer.seek(to: current)
         state.currentTime = current
         return .none
      case .updateTime(let current):
        state.currentTime = musicPlayer.currentTime()
        return .none
      default:
        return .none
      }
    }
  }
}
