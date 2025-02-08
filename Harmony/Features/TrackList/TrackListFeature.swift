//
//  TrackListFeature.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import ComposableArchitecture

@Reducer
struct TrackListFeature {

  @ObservableState
  struct State: Equatable {
  }

  enum ViewAction {
    case showTrackDetail
  }

  enum Action {
    case view(ViewAction)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(let action):
        switch action {
        case .showTrackDetail:
          return .none
        }
      }
    }
  }
}
