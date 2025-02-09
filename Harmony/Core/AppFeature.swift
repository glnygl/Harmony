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
  }

  enum Action {
    case selectTab(SelectedTab)
    case listAction(TrackListFeature.Action)
    case favoritesAction(FavoritesFeature.Action)
  }

  var body: some ReducerOf<Self> {

    Reduce { state, action in
      return .none
    }

    Scope(state: \.listState, action: \.listAction) { TrackListFeature() }
    Scope(state: \.favoritesState, action: \.favoritesAction) { FavoritesFeature() }
  }
}
