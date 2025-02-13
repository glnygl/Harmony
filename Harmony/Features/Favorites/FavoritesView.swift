//
//  FavoritesView.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct FavoritesView: View {

  @Bindable var store: StoreOf<FavoritesFeature>

  var body: some View {
    NavigationStack {
      if store.trackList.isEmpty {
        VStack(spacing: 8) {
          Image("music")
            .resizable()
            .frame(width: 80, height: 80)
          VStack(spacing: 4) {
            Text("No Favorites")
              .font(.system(size: 18, weight: .semibold))
            Text("You can add tracks to your favorites by clicking heart button.")
              .font(.system(size: 16))
              .multilineTextAlignment(.center)
              .foregroundStyle(.gray)
          }
        }
        .padding(.horizontal, 20)
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
      } else {
        ScrollView {
          LazyVStack {
            ForEach(store.trackList, id:\.id) { track in
              VStack(alignment: .leading) {
                Button(action: {
                  store.send(.listRowSelected(track))
                }) {
                  TrackListRowView(track: track)
                }
                .buttonStyle(PlainButtonStyle())
                Divider()
              }
            }
          }
          .scrollIndicators(.hidden)
          .fullScreenCover(
            item: $store.scope(state: \.trackDetailState, action: \.showTrackDetail)
          ) { detailStore in
            NavigationStack {
              TrackDetailView(store: detailStore)
            }
          }
          .navigationTitle("Favorites")
          .navigationBarTitleDisplayMode(.inline)
        }
        .padding(.horizontal)
      }
    }
    .onAppear {
      store.send(.fetchFavorites)
    }
  }
}

#Preview {
  FavoritesView(
    store: Store(initialState: FavoritesFeature.State()) {
      FavoritesFeature()
    }
  )
}
