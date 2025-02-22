//
//  AppFeature.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import ComposableArchitecture

@Reducer
struct AppFeature {
  
  enum SelectedTab {
      case list
      case favorites
  }

  @ObservableState
  struct State: Equatable {
    var selectedTab: SelectedTab = .list
    var listState = TrackListFeature.State()
    var favoritesState = FavoritesFeature.State()
    var currentlyPlaying: CurrentlyPlayingBarFeature.State?

    var trackDetailFeature:  TrackDetailFeature.State? {
      self.listState.destination?.details ?? self.favoritesState.trackDetailState
    }
  }

  enum Action {
    case selectTab(SelectedTab)
    case listAction(TrackListFeature.Action)
    case favoritesAction(FavoritesFeature.Action)
    case currentlyPlaying(CurrentlyPlayingBarFeature.Action)
  }

  private func details(_ state: inout State, action: Action) -> Effect<Action> {
    switch action {
      case let .listAction(trackList):
        switch trackList {
          case .destination(.presented(.details(.dismissButtonTapped))):
            return handleTrackDetailsDismissing(&state)
          case .listRowSelected:
            state.currentlyPlaying = nil
            return .none
          default:
            return .none
        }
      case .favoritesAction(.showTrackDetail(.presented(.dismissButtonTapped))):
        return handleTrackDetailsDismissing(&state)
      case .favoritesAction(.listRowSelected):
        state.currentlyPlaying = nil
        return .none
      default:
        return .none
    }
  }

  var body: some ReducerOf<Self> {

    CombineReducers {
      Reduce(self.details)

      Scope(state: \.listState, action: \.listAction) { TrackListFeature() }
      Scope(state: \.favoritesState, action: \.favoritesAction) { FavoritesFeature() }

    }
    .ifLet(\.currentlyPlaying, action: \.currentlyPlaying) {
      CurrentlyPlayingBarFeature()
    }

  }

  private func handleTrackDetailsDismissing(_ state: inout State) -> Effect<Action> {
    guard let trackDetailFeature = state.trackDetailFeature else { return .none }
        let track = trackDetailFeature.track
        let isPlaying = trackDetailFeature.playerControlState.isPlaying
        if isPlaying {
          guard let trackName = track.trackName, let artistName = track.artistName, let albumArt = track.img else { return .none }
          state.currentlyPlaying = CurrentlyPlayingBarFeature.State(
              trackName: trackName,
              artistName: artistName,
              isPlaying: true,
              albumArt: albumArt
          )
        }
        return .none
  }
}
