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
      Artist(id: 3, name: "Harry Styles", image: "harry"),
      Artist(id: 4, name: "Dua Lipa", image: "dualipa"),
      Artist(id: 5, name: "Rihanna", image: "rihanna"),
      Artist(id: 6, name: "Troye Sivan", image: "troye"),
      Artist(id: 7, name: "Miley Cyrus", image: "miley"),
      Artist(id: 8, name: "Adele", image: "adele"),
      Artist(id: 9, name: "Shawn Mendes", image: "shawn"),
      Artist(id: 10, name: "Camila Cabello", image: "camilla"),
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
