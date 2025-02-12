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
      Artist(id: 6, name: "Taylor Swift", image: "taylor"),
      Artist(id: 7, name: "Selena Gomez", image: "selena"),
      Artist(id: 8, name: "Troye Sivan", image: "troye"),
      Artist(id: 9, name: "Miley Cyrus", image: "miley"),
      Artist(id: 10, name: "Adele", image: "adele"),
      Artist(id: 11, name: "Charlie Puth", image: "charlie"),
      Artist(id: 12, name: "Sabrina Carpenter", image: "sabrina"),
      Artist(id: 13, name: "Camila Cabello", image: "camilla"),
      Artist(id: 14, name: "Shawn Mendes", image: "shawn"),
      Artist(id: 15, name: "Kesha", image: "kesha"),
      Artist(id: 16, name: "Usher", image: "usher"),
      Artist(id: 17, name: "Billie Eilish", image: "billie"),
      Artist(id: 18, name: "Anne-Marie", image: "anne"),
      Artist(id: 19, name: "Tate McRae", image: "tate"),
      Artist(id: 20, name: "Madonna", image: "madonna"),
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
