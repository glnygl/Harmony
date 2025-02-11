//
//  TrackDetailFeature.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TrackDetailFeature {

  @ObservableState
  struct State: Equatable {
    var track: TrackResponse
    var musicURL: String?
    var isPlaying: Bool = false
    var isLoading: Bool = true
    var isFavorite: Bool = false
    var currentTime: Double = 0
    var totalDuration: Double = 0
    var volume: Double = 0.5
    var playStatus: PlayStatus = .once
  }

  enum Action {
    case setMusicURL(String)
    case playPauseTapped(Bool)
    case seek(Double)
    case updateVolume(Double)
    case updateTime(Double)
    case setInitialTime(Double, Double)
    case setPlayStatus(PlayStatus)
    case infoButtonTapped
    case openURLResponse(TaskResult<Bool>)
    case dismissButtonTapped
  }

  @Dependency(\.musicPlayer) var musicPlayer
  @Dependency(\.openURL) var openURL

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .setMusicURL(let url):
        state.musicURL = url
        return .run { send in
          do {
            let duration = try await musicPlayer.setURL(url)
            await send(.setInitialTime(musicPlayer.currentTime(), duration))
          } catch {
            print(error)
          }
        }
      case .playPauseTapped(let shouldPlay):
        state.isPlaying = shouldPlay
        if shouldPlay {
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
        state.isLoading = false
        return .send(.playPauseTapped(true))
      case .seek(let current):
        state.currentTime = current
        musicPlayer.seek(to: current)
        return .none
      case let .updateTime(time):
        state.currentTime = time
        if time >= state.totalDuration {
          if state.playStatus == .once {
            state.isPlaying = false
            return .run { send in
                await send(.seek(0))
                await send(.playPauseTapped(false) )
            }
          } else if state.playStatus == .again {
            state.playStatus = .once
            return .run { send in
                await send(.seek(0))
                await send(.playPauseTapped(true) )
            }
          } else {
            return .run { send in
                await send(.seek(0))
                await send(.playPauseTapped(true) ) 
            }
          }
        }
        return .none
      case .setPlayStatus(var status):
        status.next()
        state.playStatus = status
        return .none
      case .infoButtonTapped:
        guard let url = URL(string: state.track.infoURL ?? "") else { return .none }
        return .run { send in
            await send(.openURLResponse(
                TaskResult {
                    await openURL(url)
                }
            ))
        }
      case .openURLResponse(.success(_)):
        musicPlayer.pause()
        return .none
      case .openURLResponse(.failure(_)):
        return .none
      case .dismissButtonTapped:
        musicPlayer.pause()
        return .none
      }
    }
  }
}
