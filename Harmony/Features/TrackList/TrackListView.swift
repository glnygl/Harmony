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
          // TODO
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

struct SearchResultRow: View {
  let result: TrackResponse

  var body: some View {
    VStack(alignment: .leading) {
      Text(result.trackName ?? "")
        .font(.headline)
    }
    .padding(.vertical, 4)
  }
}

#Preview {
  TrackListView(
    store: Store(initialState: TrackListFeature.State()) {
      TrackListFeature()
    }
  )
}

