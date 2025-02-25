//
//  TrackControlView.swift
//  Harmony
//
//  Created by Glny Gl on 11/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct TrackControlView: View {

  let store: StoreOf<TrackControlFeature>

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
          store.send(.muteVolume(!store.isMute))
        }) {
          ZStack {
              Image(systemName: "speaker.wave.2")
              .font(.system(size: 24))
              if store.isMute {
                  Rectangle()
                      .frame(width: 30, height: 2)
                      .rotationEffect(.degrees(54))
                      .foregroundColor(.gray)
              }
          }
          .foregroundColor(.gray)
        }

        Button(action: {
          store.send(.favoriteButtonTapped(!store.isFavorite))
        }) {
          Image(systemName: store.isFavorite ? "heart.fill" : "heart")
            .font(.system(size: 24))
            .foregroundColor(store.isFavorite ? .red : .gray)
        }

        Button(action: {
          store.send(.setPlayStatus)
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

