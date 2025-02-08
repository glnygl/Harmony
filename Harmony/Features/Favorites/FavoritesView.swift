//
//  FavoritesView.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct FavoritesView: View {

  let store: StoreOf<FavoritesFeature>

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
  FavoritesView(
    store: Store(initialState: FavoritesFeature.State()) {
      FavoritesFeature()
     }
   )
}
