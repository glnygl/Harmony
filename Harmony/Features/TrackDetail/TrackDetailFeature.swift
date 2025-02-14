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

  @Dependency(\.openURL) var openURL
  @Dependency(\.musicPlayer) var musicPlayer
  @Dependency(\.favoriteService) var favoriteService

  @ObservableState
  struct State: Equatable {
    var track: TrackResponse
    var musicURL: String?
    var isLoading: Bool = true
    var showPopover: Bool = false
    var currentTime: Double = 0
    var totalDuration: Double = 0
    var playerControlState = PlayerControlFeature.State()
    var trackControlState = TrackControlFeature.State()
    var volumeControlState = VolumeControlFeature.State()
  }

  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case setMusicURL(String)
    case seek(Double)
    case updateTime(Double)
    case setInitialTime(Double, Double)
    case openURLResponse(TaskResult<Bool>)
    case dismissButtonTapped
    case addFavorite(TrackResponse)
    case deleteFavorite(TrackResponse)
    case checkIsFavorite
    case playerControlAction(PlayerControlFeature.Action)
    case trackControlAction(TrackControlFeature.Action)
    case volumeControlAction(VolumeControlFeature.Action)
  }

  var body: some ReducerOf<Self> {
    BindingReducer()

    Scope(state: \.playerControlState, action: \.playerControlAction) { PlayerControlFeature() }
    Scope(state: \.trackControlState, action: \.trackControlAction) { TrackControlFeature() }
    Scope(state: \.volumeControlState, action: \.volumeControlAction) { VolumeControlFeature() }

    Reduce { state, action in
      switch action {
      case .binding(\.showPopover):
        return .none
      case .binding(_):
        return .none
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
      case .setInitialTime(let current, let duration):
        state.currentTime = current
        state.totalDuration = duration
        state.isLoading = false
        return .send(.playerControlAction(.playPauseTapped(true)))
      case .seek(let current):
        state.currentTime = current
        musicPlayer.seek(current)
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
      case .addFavorite(let track):
        return .run { send in
          do {
            try favoriteService.addFavorite(item: track)
          } catch {
            print(error)
          }
        }
      case .deleteFavorite(let track):
        return .run { send in
          do {
            try favoriteService.deleteFavorite(item: track)
          } catch {
            print(error)
          }
        }
      case .checkIsFavorite:
        state.trackControlState.isFavorite = favoriteService.isFavorite(trackID: state.track.id)
        return .none
      case .openURLResponse(.success(_)):
        musicPlayer.pause()
        return .send(.playerControlAction(.playPauseTapped(false)))
      case .openURLResponse(.failure(_)):
        return .none
      case .dismissButtonTapped:
        musicPlayer.pause()
        return .none
      case .playerControlAction(.playPauseTapped(let shouldPlay)):
        if shouldPlay {
          musicPlayer.play()
        } else {
          musicPlayer.pause()
        }
        return .none
      case .playerControlAction(.rewindTapped):
        if state.currentTime < 10 {
          state.currentTime = 0
          musicPlayer.seek(state.currentTime)
        } else {
          state.currentTime -= 10
          musicPlayer.seek(state.currentTime)
        }
        return .none
      case .playerControlAction(.forwardTapped):
        if state.currentTime + 10 <= state.totalDuration {
          state.currentTime += 10
          musicPlayer.seek(state.currentTime)
        }
        return .none
      case .trackControlAction(.setPlayStatus(_)):
        return .none
      case .trackControlAction(.favoriteButtonTapped(let isFavorite)):
        if isFavorite {
          return .send(.addFavorite(state.track))
        } else {
          return .send(.deleteFavorite(state.track))
        }
      case .trackControlAction(.infoButtonTapped):
        guard let url = URL(string: state.track.infoURL ?? "") else { return .none }
        return .run { send in
          await send(.openURLResponse(
            TaskResult {
              await openURL(url)
            }
          ))
        }
      case .trackControlAction(.muteVolume(let value)):
        state.trackControlState.isMute = value

        if value {
          state.volumeControlState.previousVolume = state.volumeControlState.volume
          state.volumeControlState.volume = 0
        } else {
          state.volumeControlState.volume = state.volumeControlState.previousVolume
        }

        return .send(.volumeControlAction(.updateVolume(state.volumeControlState.volume)))
      case .volumeControlAction(.updateVolume(let volume)):
        musicPlayer.setVolume(volume)
        state.trackControlState.isMute = (volume == 0)
        return .none
      }
    }
  }
}
