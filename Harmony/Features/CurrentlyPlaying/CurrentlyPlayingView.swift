//
//  NowPlayingBar.swift
//  Harmony
//
//  Created by Ibrahim Kteish on 21/2/25.
//


import ComposableArchitecture
import SwiftUI
import NukeUI

struct CurrentlyPlayingView: View {

  @Bindable var store: StoreOf<CurrentlyPlayingFeature>
  @State private var averageColor: Color = .white

  var body: some View {
      VStack(spacing: 4) {
          HStack(spacing: 16) {
              LazyImage(url: URL(string: store.trackResponse.img ?? "")) { state in
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
                          .fill(.gray.opacity(1))
                          .frame(width: 48, height: 48)
                  }
              }
              VStack(alignment: .leading, spacing: 2) {
                  Text(store.trackResponse.trackName ?? "")
                      .font(.headline)
                      .foregroundColor(.white)
                      .lineLimit(1)
                  Text(store.trackResponse.artistName ?? "")
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
          
          ZStack(alignment: .leading) {
              // Background track
              Rectangle()
                  .fill(Color.white.opacity(0.3))
                  .frame(height: 4)
                  .cornerRadius(2)
              
              // Progress bar
              Rectangle()
                  .fill(Color.white)
                  .frame(width: max(0, min(UIScreen.main.bounds.width - 16, CGFloat(store.currentTime / max(0.001, store.duration)) * (UIScreen.main.bounds.width - 16))), height: 4)
                  .cornerRadius(2)
          }
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
    .onReceive(Timer.publish(every: 1, on: .main, in: .default).autoconnect()) { _ in
      if store.isPlaying {
        store.send(.updateTime)
      }
    }
  }
}


#Preview(traits: .sizeThatFitsLayout) {
  CurrentlyPlayingView(
    store: .init(
      initialState: CurrentlyPlayingFeature.State.init(
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
      reducer: { CurrentlyPlayingFeature()
      }
    )
  )
}

