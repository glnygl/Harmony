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
  @Dependency(\.dismiss) var dismiss

  @ObservableState
  struct State: Equatable {
    var track: TrackResponse
    var musicURL: String? = nil
    var isLoading: Bool = true
    var showPopover: Bool = false
    var currentTime: Double = 0
    var totalDuration: Double = 0
    var playerControlState = PlayerControlFeature.State()
    var trackControlState: TrackControlFeature.State
    var volumeControlState = VolumeControlFeature.State()

    init(track: TrackResponse) {
      self.track = track
      self.trackControlState = .init(trackId: track.id)
    }
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case setMusicURL(String)
    case seek(Double)
    case updateTime(Double)
    case setInitialTime(Double, Double)
    case openURLResponse(TaskResult<Bool>)
    case dismissButtonTapped
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
      case .binding:
        return .none
      case .setMusicURL(let url):
        return setMusicURL(&state, url: url)
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
        return setCurrentTime(&state, time: time)
      case .openURLResponse(.success(_)):
        musicPlayer.pause()
        return .send(.playerControlAction(.playPauseTapped(false)))
      case .openURLResponse(.failure(_)):
        return .none
      case .dismissButtonTapped:
          return .run { _ in await self.dismiss() }
      case .playerControlAction(.playPauseTapped(let shouldPlay)):
        if shouldPlay {
          musicPlayer.play()
        } else {
          musicPlayer.pause()
        }
        return .none
      case .playerControlAction(.rewindTapped):
        setForwardState(&state, isRewind: true)
        return .none
      case .playerControlAction(.forwardTapped):
        setForwardState(&state, isRewind: false)
        return .none
      case .trackControlAction(.setPlayStatus(_)):
        return .none
        case let .trackControlAction(.favoriteButtonTapped(isFavorite)):
          let track = state.track
          return .run { _ in
            if isFavorite {
              try await self.favoriteService.addFavorite(track)
            } else {
              try await self.favoriteService.deleteFavorite(track)
            }
          } catch: { _, error in
            // Handle later on
            print(error)
          }
      case .trackControlAction(.infoButtonTapped):
        return redirectURL(&state)
      case .trackControlAction(.muteVolume(let value)):
        return setMuteState(&state, isMute: value)

      case .volumeControlAction(.updateVolume(let volume)):
        musicPlayer.setVolume(volume)
        state.trackControlState.isMute = (volume == 0)
        return .none
      }
    }

  }
  
  private func setMusicURL(_ state: inout State, url: String) -> Effect<Action> {
    state.musicURL = url
    return .run { send in
      do {
        let duration = try await musicPlayer.setURL(url)
        await send(.setInitialTime(musicPlayer.currentTime(), duration))
      } catch {
        print(error)
      }
    }
  }
  
  private func setCurrentTime(_ state: inout State, time: Double) -> Effect<Action> {
    state.currentTime = time
    if time >= state.totalDuration {
      let shouldPause = (state.trackControlState.playStatus == .once)
      if state.trackControlState.playStatus == .again {
        state.trackControlState.playStatus = .once
      }
      
      return .run { send in
        await send(.seek(0))
        await send(.playerControlAction(.playPauseTapped(!shouldPause)))
      }
    }
    return .none
  }
  
  private func setForwardState(_ state: inout State, isRewind: Bool) {
    if isRewind {
      state.currentTime = max(0, state.currentTime - 10)
    } else if state.currentTime + 10 <= state.totalDuration {
      state.currentTime += 10
    }
    musicPlayer.seek(state.currentTime)
  }
  
  private func redirectURL(_ state: inout State) -> Effect<Action> {
    guard let url = URL(string: state.track.infoURL ?? "") else { return .none }
    return .run { send in
      await send(.openURLResponse(
        TaskResult {
          await openURL(url)
        }
      ))
    }
  }
  
  private func setMuteState(_ state: inout State, isMute: Bool) -> Effect<Action> {
    state.trackControlState.isMute = isMute
    
    if isMute {
      state.volumeControlState.previousVolume = state.volumeControlState.volume
      state.volumeControlState.volume = 0
    } else {
      state.volumeControlState.volume = state.volumeControlState.previousVolume
    }
    return .send(.volumeControlAction(.updateVolume(state.volumeControlState.volume)))
  }
}
