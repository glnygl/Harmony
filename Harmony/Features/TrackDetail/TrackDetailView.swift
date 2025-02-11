//
//  TrackDetailView.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import SwiftUI
import NukeUI
import ComposableArchitecture

struct TrackDetailView: View {
  var store: StoreOf<TrackDetailFeature>

  var body: some View {
    VStack {
      Button(action: {
        store.send(.dismissButtonTapped)
      }) {
        Image(systemName: "chevron.compact.down")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 40, height: 20)
          .foregroundStyle(.gray)
      }

      Spacer()

      VStack(spacing: 10) {
        LazyImage(url:URL(string: store.track.img!.replacingOccurrences(of: "100x100", with: "600x600"))) { state in
          if let image = state.image {
            image.resizable()
              .frame(width: 320, height: 320)
          } else {
            Rectangle()
              .fill(.gray.opacity(0.2))
              .frame(width: 320, height: 320)
          }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))

        Slider(
          value: Binding<Double>(
            get: { self.store.state.currentTime },
            set: { newValue in
              self.store.send(.seek(newValue))
            }
          ), in: 0...store.totalDuration
        )
        .accentColor(.gray)
        .padding(.horizontal, 10)
        .overlay(alignment: .bottomLeading) {
          Text(store.currentTime.formatTime())
            .font(.caption)
            .foregroundColor(.gray)
            .offset(x: 10, y: 12)
        }
        .overlay(alignment: .bottomTrailing) {
          Text((store.totalDuration - store.currentTime).formatTime())
            .font(.caption)
            .foregroundColor(.gray)
            .offset(x: -10, y: 12)
        }
      }

      VStack(spacing: 8) {
        Text(store.track.trackName ?? "")
          .font(.title2)
          .fontWeight(.semibold)
          .lineLimit(1)

        Text(store.track.artistName ?? "")
          .font(.title3)
          .foregroundColor(.gray)
          .lineLimit(1)
      }
      .padding(.top, 20)

      PlayerControlView(store: store.scope(state: \.playerControlState, action: \.playerControlAction))
      .padding(.vertical, 20)


      HStack {
        Image(systemName: "speaker.fill")
        Slider(
          value: Binding<Double>(
            get: { self.store.state.volume },
            set: { newValue in
              self.store.send(.updateVolume(newValue))
            }
          ), in: 0...1
        )
        Image(systemName: "speaker.wave.3.fill")
      }
      .foregroundStyle(.gray)
      .padding(.horizontal, 30)
      .padding(.top, 10)

      TrackControlView(store: store.scope(state: \.trackControlState, action: \.trackControlAction))
      .padding(.vertical, 20)
      .padding(.top, 20)

    }
    .showLoadingView(isLoading: store.isLoading)
    .padding()
    .background(Color.white.ignoresSafeArea())
    .onAppear {
      store.send(.setMusicURL(store.track.url ?? ""))
    }
    .onReceive(Timer.publish(every: 1, on: .main, in: .default).autoconnect()) { _ in
      if store.playerControlState.isPlaying {
        store.send(.updateTime(store.currentTime + 1))
        }
    }
  }
}

#Preview {
  TrackDetailView(
    store: Store(initialState: TrackDetailFeature.State(track: TrackResponse(id: 1, img: "", url: "", trackName: "rihanna", artistName: "rihanna", collectionName: "", infoURL: ""))) {
      TrackDetailFeature()
    }
  )
}
