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
    var isLoading: Bool = true
    var currentTime: Double = 0
    var totalDuration: Double = 0
    var volume: Double = 0.5
//    var playStatus: PlayStatus = .once
    var playerControlState = PlayerControlFeature.State()
    var trackControlState = TrackControlFeature.State()
  }

  enum Action {
    case setMusicURL(String)
    case seek(Double)
    case updateVolume(Double)
    case updateTime(Double)
    case setInitialTime(Double, Double)
    case openURLResponse(TaskResult<Bool>)
    case dismissButtonTapped
    case playerControlAction(PlayerControlFeature.Action)
    case trackControlAction(TrackControlFeature.Action)
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
      case .playerControlAction(.playPauseTapped(let shouldPlay)):
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
        return .send(.playerControlAction(.playPauseTapped(true)))
      case .seek(let current):
        state.currentTime = current
        musicPlayer.seek(to: current)
        return .none
      case let .updateTime(time):
        state.currentTime = time
        if time >= state.totalDuration {
          if state.trackControlState.playStatus == .once {
            return .run { send in
              await send(.seek(0))
              await send(.playerControlAction(.playPauseTapped(false)))
            }
          } else if state.trackControlState.playStatus == .again {
            state.trackControlState.playStatus = .once
            return .run { send in
              await send(.seek(0))
              await send(.playerControlAction(.playPauseTapped(true)))
            }
          } else {
            return .run { send in
              await send(.seek(0))
              await send(.playerControlAction(.playPauseTapped(true)))
            }
          }
        }
        return .none
      case .trackControlAction(.setPlayStatus(_)):
        return .none
      case .trackControlAction(.infoButtonTapped):
        guard let url = URL(string: state.track.infoURL ?? "") else { return .none }
        return .run { send in
          await send(.openURLResponse(
            TaskResult {
              await openURL(url)
            }
          ))
        }
      case .trackControlAction(.muteVolume(_)):
        return .none
      case .openURLResponse(.success(_)):
        musicPlayer.pause()
        return .none
      case .openURLResponse(.failure(_)):
        return .none
      case .dismissButtonTapped:
        musicPlayer.pause()
        return .none
      case .playerControlAction(.rewindTapped):
        if state.currentTime < 10 {
          state.currentTime = 0
          musicPlayer.seek(to: state.currentTime)
        } else {
          state.currentTime -= 10
          musicPlayer.seek(to: state.currentTime)
        }
        return .none
      case .playerControlAction(.forwardTapped):
        if state.currentTime + 10 <= state.totalDuration {
          state.currentTime += 10
          musicPlayer.seek(to: state.currentTime)
        }
        return .none
      }
    }

    Scope(state: \.playerControlState, action: \.playerControlAction) { PlayerControlFeature() }
    Scope(state: \.trackControlState, action: \.trackControlAction) { TrackControlFeature() }
  }
}
