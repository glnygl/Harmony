//
//  TrackListView.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct TrackListView: View {

  @Bindable var store: StoreOf<TrackListFeature>
  @FocusState private var isSearchFocused: Bool

  var body: some View {
    NavigationStack {
      VStack {
        if store.searchText.isEmpty && !isSearchFocused {
          VStack {
            PopularArtistsView(store: store.scope(state: \.popularArtistsState, action: \.popularArtistsAction))
          }
        } else {
          List {
            ForEach(store.trackList, id:\.id) { track in
              TrackListRowView(track: track)
                .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                .onTapGesture {
                  store.send(.listRowSelected(track))
                }
            }
          }
          .listStyle(.plain)
          .scrollIndicators(.hidden)
        }
      }
      .searchable(text: $store.searchText, prompt: "Search for tracks")
      .searchFocused($isSearchFocused)
      .navigationTitle("Songs")
      .navigationBarTitleDisplayMode(.inline)
    }
    .fullScreenCover(
      item: $store.scope(state: \.trackDetailState, action: \.showTrackDetail)
    ) { detailStore in
      NavigationStack {
        TrackDetailView(store: detailStore)
      }
    }
  }
}

#Preview {
  TrackListView(
    store: Store(initialState: TrackListFeature.State()) {
      TrackListFeature()
    }
  )
}

