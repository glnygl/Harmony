//
//  NowPlayingBar.swift
//  Harmony
//
//  Created by Ibrahim Kteish on 21/2/25.
//


import ComposableArchitecture
import SwiftUI

struct CurrentlyPlayingBarView: View {

  @Bindable var store: StoreOf<CurrentlyPlayingBarFeature>

  init(store: StoreOf<CurrentlyPlayingBarFeature>) {
    self.store = store
  }

    var body: some View {
        HStack(spacing: 16) {
            // Album Artwork
          Image(store.albumArt)
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .cornerRadius(4)
            
            // Track info
            VStack(alignment: .leading, spacing: 2) {
              Text(store.trackName)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
              Text(store.artistName)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "hifispeaker.fill")
                .font(.title2)
                .foregroundColor(.white)
            
            Button(action: {
              store.send(.playButtonTapped)
            }) {
              Image(systemName: store.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.leading, 8)
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
        .background(Color(red: 0.4, green: 0.2, blue: 0.0))
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.horizontal, 4)
    }
}


#Preview(traits: .sizeThatFitsLayout) {
  CurrentlyPlayingBarView(
    store: .init(
      initialState: CurrentlyPlayingBarFeature.State.init(
        trackName: "Revolution",
        artistName: "Måns Zelmerlöw",
        isPlaying: true,
        albumArt: "H"
      ),
      reducer: { CurrentlyPlayingBarFeature() }
    )
  )
}
