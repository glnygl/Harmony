//
//  PopularGenreFeature.swift
//  Harmony
//
//  Created by Glny Gl on 10/02/2025.
//

import ComposableArchitecture

@Reducer
struct PopularGenreFeature {

  @ObservableState
  struct State: Equatable {
    var genres: [MusicGenre] = MusicGenre.allCases
  }

  enum Action {
    case genreSelected(MusicGenre)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .genreSelected(_):
        return .none
      }
    }
  }
}
