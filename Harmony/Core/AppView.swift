//
//  AppView.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {

  let store: StoreOf<AppFeature>

    var body: some View {
      TabView {
        TrackListView(store: store.scope(state: \.listState, action: \.listAction))
          .tabItem {
            Label("Home", systemImage: "house.fill")
          }

        FavoritesView(store: store.scope(state: \.favoritesState, action: \.favoritesAction))
          .tabItem {
            Label("Favorites", systemImage: "heart")
          }
      }
    }
}

#Preview {
  AppView(
     store: Store(initialState: AppFeature.State()) {
       AppFeature()
     }
   )
}
