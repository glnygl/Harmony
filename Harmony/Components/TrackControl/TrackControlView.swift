//
//  TrackControlView.swift
//  Harmony
//
//  Created by Glny Gl on 11/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct TrackControlView: View {

  var store: StoreOf<TrackControlFeature>

    var body: some View {
      HStack(spacing: 60) {
        Button(action: {
          store.send(.infoButtonTapped)
        }) {
          Image(systemName: "info.circle")
            .font(.system(size: 24))
            .foregroundColor(.gray)
        }

        Button(action: {
          // TODO: Add to favorite
        }) {
          Image(systemName: store.isMute ?  "speaker.slash" : "speaker.wave.2")
            .font(.system(size: 24))
            .foregroundColor(.gray)
        }

        Button(action: {
          // TODO: Add to favorite
        }) {
          Image(systemName: store.isFavorite ? "heart.fill" : "heart")
            .font(.system(size: 24))
            .foregroundColor(store.isFavorite ? .red : .gray)
        }

        Button(action: {
          store.send(.setPlayStatus(store.playStatus))
        }) {
          Image(systemName: store.playStatus == .forever ? "arrow.trianglehead.2.clockwise" : "arrow.trianglehead.counterclockwise")
            .id(store.playStatus)
            .contentTransition(.symbolEffect(.replace))
            .font(.system(size: 20.5))
            .foregroundStyle( store.playStatus == .once ? .gray : .green)
        }
      }
    }
}

