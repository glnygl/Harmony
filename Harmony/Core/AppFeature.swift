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

  var body: some ReducerOf<Self> {

    Scope(state: \.listState, action: \.listAction) { TrackListFeature() }
    Scope(state: \.favoritesState, action: \.favoritesAction) { FavoritesFeature() }

    Reduce { state, action in

      switch action {
        case let .listAction(trackList):
          switch trackList {
            case .destination(.presented(.details(.dismissButtonTapped))):
              state.listState.isCurrentlyPlaying = true
              state.favoritesState.isCurrentlyPlaying = true
              return handleTrackDetailsDismissing(&state)
            case .listRowSelected:
              state.currentlyPlaying = nil
              state.listState.isCurrentlyPlaying = false
              state.favoritesState.isCurrentlyPlaying = false
              return .none
            default:
              return .none
          }
        case .favoritesAction(.showTrackDetail(.presented(.dismissButtonTapped))):
          state.listState.isCurrentlyPlaying = true
          state.favoritesState.isCurrentlyPlaying = true
          return handleTrackDetailsDismissing(&state)
        case .favoritesAction(.listRowSelected):
          state.currentlyPlaying = nil
          state.listState.isCurrentlyPlaying = false
          state.favoritesState.isCurrentlyPlaying = false
          return .none
        case let .currentlyPlaying(.delegate(delegateAction)):
          switch delegateAction {
            case let .tapped(trackResponse):
              return .send(.listAction(.listRowSelected(trackResponse)))
          }
        default:
          return .none
      }

    }
    .ifLet(\.currentlyPlaying, action: \.currentlyPlaying) {
      CurrentlyPlayingBarFeature()
    }
  }

  private func handleTrackDetailsDismissing(_ state: inout State) -> Effect<Action> {
    guard let trackDetailFeature = state.trackDetailFeature else { return .none }
    let track = trackDetailFeature.track
    let isPlaying = trackDetailFeature.playerControlState.isPlaying
    state.currentlyPlaying = CurrentlyPlayingBarFeature.State(
      trackResponse: track,
      isPlaying: isPlaying
    )
    return .none
  }
}
