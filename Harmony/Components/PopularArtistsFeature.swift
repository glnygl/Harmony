//
//  PopularArtistsFeature.swift
//  Harmony
//
//  Created by Glny Gl on 09/02/2025.
//

import ComposableArchitecture

@Reducer
struct PopularArtistsFeature {

  @ObservableState
  struct State: Equatable {
    var artists: [Artist] = [
      Artist(id: 1, name: "Britney Spears", image: "britney"),
      Artist(id: 2, name: "Shakira", image: "shakira"),
      Artist(id: 3, name: "Rihanna", image: "rihanna"),
      Artist(id: 4, name: "Taylor Swift", image: "taylor"),
      Artist(id: 5, name: "Billie Eilish", image: "billie"),
      Artist(id: 6, name: "Dua Lipa", image: "dualipa")
    ]
  }

  enum Action {
    case artistSelected(String)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .artistSelected(_):
        return .none
      }
    }
  }
}
