//
//  PlayerControlView.swift
//  Harmony
//
//  Created by Glny Gl on 11/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct PlayerControlView: View {

  var store: StoreOf<PlayerControlFeature>

    var body: some View {
      HStack(spacing: 28) {
        Button(action: {
          store.send(.rewindTapped)
        }) {
          Image(systemName: "10.arrow.trianglehead.counterclockwise")
            .font(.title3)
            .foregroundColor(.black)
        }

        HStack(spacing: 40) {
          Button(action: {
            // TODO: Previous song
          }) {
            Image(systemName: "backward.fill")
              .font(.title)
              .foregroundColor(.black)
          }

          Button(action: {
            store.send(.playPauseTapped(!store.isPlaying))
          }) {
            Image(systemName: store.isPlaying ? "pause.fill" : "play.fill")
              .font(.system(size: 50))
              .foregroundColor(.black)
          }

          Button(action: {
            // TODO: Next song
          }) {
            Image(systemName: "forward.fill")
              .font(.title)
              .foregroundColor(.black)
          }
        }

        Button(action: {
          store.send(.forwardTapped)
        }) {
          Image(systemName: "10.arrow.trianglehead.clockwise")
            .font(.title3)
            .foregroundColor(.black)
        }
      }
    }
}
