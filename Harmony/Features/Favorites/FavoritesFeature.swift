//
//  FavoritesFeature.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import ComposableArchitecture

@Reducer
struct FavoritesFeature {

  @ObservableState
  struct State: Equatable {
  }

  enum ViewAction {
    case addToFavorites
  }

  enum Action {
    case view(ViewAction)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(let action):
        switch action {
        case .addToFavorites:
          return .none
        }
      }
    }
  }
}
