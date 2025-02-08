//
//  TrackListView.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct TrackListView: View {

  let store: StoreOf<TrackListFeature>

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
  TrackListView(
    store: Store(initialState: TrackListFeature.State()) {
      TrackListFeature()
     }
   )
}

