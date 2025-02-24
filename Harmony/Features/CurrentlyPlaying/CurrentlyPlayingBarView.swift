//
//  NowPlayingBar.swift
//  Harmony
//
//  Created by Ibrahim Kteish on 21/2/25.
//


import ComposableArchitecture
import SwiftUI
import NukeUI

struct CurrentlyPlayingBarView: View {

  @Bindable var store: StoreOf<CurrentlyPlayingBarFeature>
  @State private var averageColor: Color = .white

  init(store: StoreOf<CurrentlyPlayingBarFeature>) {
    self.store = store
  }

  var body: some View {
    HStack(spacing: 16) {
      LazyImage(url: URL(string: store.albumArt)) { state in
        if let image = state.image {
          image
            .resizable()
            .scaledToFill()
            .frame(width: 48, height: 48)
            .cornerRadius(4)
            .onAppear {
              if let uiColor = state.imageContainer?.image.averageColor {
                averageColor = Color(uiColor)
              }
            }
        } else {
          Rectangle()
            .fill(.black)
            .frame(width: 48, height: 48)
        }
      }
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
      
      Button(action: {
        store.send(.playButtonTapped)
      }) {
        Image(systemName: store.isPlaying ? "pause.fill" : "play.fill")
          .font(.title2)
          .foregroundColor(.white)
          .padding(.leading, 8)
      }
      .padding(.trailing, 10)
    }
    .padding(.horizontal, 4)
    .padding(.vertical, 4)
    .background(averageColor)
    .cornerRadius(8)
    .shadow(radius: 2)
    .padding(.horizontal, 4)
    .onTapGesture {
      self.store.send(.viewTapped)
    }
  }
}


#Preview(traits: .sizeThatFitsLayout) {
  CurrentlyPlayingBarView(
    store: .init(
      initialState: CurrentlyPlayingBarFeature.State.init(
        trackResponse: .init(
          id: 1,
          img: "img",
          url: "url",
          trackName: "Name",
          artistName: "Artist Name",
          collectionName: "collection",
          infoURL: "infoURL"
        ),
        isPlaying: true
      ),
      reducer: { CurrentlyPlayingBarFeature()
      }
    )
  )
}

