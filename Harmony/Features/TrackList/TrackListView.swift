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
          ScrollView {
            VStack(alignment: .leading, spacing: 20) {
              PopularGenreView(store: store.scope(state: \.popularGenresState, action: \.popularGenresAction))
              PopularArtistsView(store: store.scope(state: \.popularArtistsState, action: \.popularArtistsAction))

              VStack(alignment: .leading, spacing: 10) {
                Text("Grammy Winners")
                  .font(.system(size: 18))
                  .fontWeight(.bold)
                  .padding(.horizontal)
                  .foregroundStyle(.black).opacity(0.6)

                ForEach(store.grammyTrackList, id: \.id) { track in
                  VStack(alignment: .leading) {
                    TrackListRowView(track: track)
                      .onTapGesture {
                        store.send(.listRowSelected(track))
                      }
                    Divider()
                  }
                  .padding(.horizontal, 20)
                }
              }
              .padding(.top, -16)
            }
            .padding(.top, 4)
            .padding(.bottom, 10)
          }
          .scrollIndicators(.hidden)
        } else {
          ScrollView {
            LazyVStack {
              ForEach(store.trackList, id:\.id) { track in
                VStack(alignment: .leading) {
                  TrackListRowView(track: track)
                    .onTapGesture {
                      store.send(.listRowSelected(track))
                    }
                  Divider()
                }
              }
            }
          }
          .scrollIndicators(.hidden)
          .padding(.horizontal)
        }
      }
      .searchable(text: $store.searchText, prompt: "What do you want to listen to?")
      .onChange(of: store.searchText) { 
          store.send(.searchTrackList)
      }
      .searchFocused($isSearchFocused)
      .navigationTitle("Discover")
      .navigationBarTitleDisplayMode(.inline)
    }
    .alert("Error", isPresented: Binding(
      get: { !store.error.isEmpty },
      set: { _ in store.error = "" }
    )) {
      Button("OK", role: .cancel) { }
    } message: {
      Text(store.error)
    }
    .fullScreenCover(
      item: $store.scope(
        state: \.destination?.details,
        action: \.destination.details
      )
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

