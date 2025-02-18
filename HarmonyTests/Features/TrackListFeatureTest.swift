//
//  TrackListFeatureTest.swift
//  Harmony
//
//  Created by Glny Gl on 18/02/2025.
//

import Testing
import Foundation
import ComposableArchitecture

@testable import Harmony

@MainActor
struct TrackListFeatureTest {

  @Test
  func testSearchAction_EmptyText() async {

    let initialState = TrackListFeature.State(searchText: "")

    let store = TestStore(initialState: initialState) {
      TrackListFeature()
    } withDependencies: { state in
      state.musicService.fetchSearchResponse = { _ in
        SearchResponse(results: [])
      }
    }
    store.exhaustivity = .off

    await store.send(.searchTrackList) { state in
      state.isLoading = false
      state.searchText = ""
    }

    await store.receive(\.cancelSearch)
  }

  @Test
  func testSearchAction_Success() async {

    let initialState = TrackListFeature.State(searchText: "Shakira")

    let testQueue = DispatchQueue.test

    let store = TestStore(initialState: initialState) {
      TrackListFeature()
    } withDependencies: { state in
      state.mainQueue = testQueue.eraseToAnyScheduler()
      state.musicService.fetchSearchResponse = { _ in
        SearchResponse(results: [])
      }
    }
    store.exhaustivity = .off

    await store.send(.searchTrackList) { state in
      state.isLoading = true
      state.searchText = "Shakira"
    }

    await testQueue.advance(by: 2)

    await store.receive(\.setTrackListResponse) { state in
      state.isLoading = false
      state.trackList = []
    }
  }

  @Test
  func testSearchAction_Failure() async {

    let initialState = TrackListFeature.State(searchText: "Shakira")

    let testQueue = DispatchQueue.test

    let store = TestStore(initialState: initialState) {
      TrackListFeature()
    } withDependencies: { state in
      state.mainQueue = testQueue.eraseToAnyScheduler()
      state.musicService.fetchSearchResponse = { _ in
        throw TestError.popularArtistsApiError
      }
    }

    store.exhaustivity = .off

    await store.send(.searchTrackList) { state in
      state.isLoading = true
      state.searchText = "Shakira"
    }

    await testQueue.advance(by: 2)

    await store.receive(\.setTrackListResponse) { state in
      state.isLoading = false
      state.error = TestError.popularArtistsApiError.localizedDescription
      state.trackList = []
    }
  }

  @Test
  func testPopularArtistsAction_EmptyText() async {

    let store = TestStore(initialState: TrackListFeature.State()) {
      TrackListFeature()
    } withDependencies: { state in
      state.musicService.fetchSearchResponse = { _ in
        SearchResponse(results: [])
      }
    }
    store.exhaustivity = .off

    await store.send(.popularArtistsAction(.artistSelected(""))) { state in
      state.isLoading = false
      state.searchText = ""
    }

    await store.receive(\.cancelSearch)
  }

  @Test
  func testPopularArtistsAction_Success() async {

    let testQueue = DispatchQueue.test

    let store = TestStore(initialState: TrackListFeature.State()) {
      TrackListFeature()
    } withDependencies: { state in
      state.mainQueue = testQueue.eraseToAnyScheduler()
      state.musicService.fetchSearchResponse = { _ in
        SearchResponse(results: [])
      }
    }
    store.exhaustivity = .off

    await store.send(.popularArtistsAction(.artistSelected("Shakira"))) { state in
      state.isLoading = true
      state.searchText = "Shakira"
    }

    await testQueue.advance(by: 2)

    await store.receive(\.setTrackListResponse) { state in
      state.isLoading = false
      state.trackList = []
    }
  }

  @Test
  func testPopularArtistsAction_Failure() async {

    let testQueue = DispatchQueue.test

    let store = TestStore(initialState: TrackListFeature.State()) {
      TrackListFeature()
    } withDependencies: { state in
      state.mainQueue = testQueue.eraseToAnyScheduler()
      state.musicService.fetchSearchResponse = { _ in
        throw TestError.popularArtistsApiError
      }
    }

    store.exhaustivity = .off

    await store.send(.popularArtistsAction(.artistSelected("Shakira"))) { state in
      state.isLoading = true
      state.searchText = "Shakira"
    }

    await testQueue.advance(by: 2)

    await store.receive(\.setTrackListResponse) { state in
      state.isLoading = false
      state.error = TestError.popularArtistsApiError.localizedDescription
      state.trackList = []
    }
  }

  @Test
  func testPopularGenresAction_Success() async {
    let store = TestStore(initialState: TrackListFeature.State()) {
      TrackListFeature()
    } withDependencies: { state in
      state.musicService.fetchGenreResponse = { _ in
        SearchResponse(results: [])
      }
    }
    store.exhaustivity = .off

    await store.send(.popularGenresAction(.genreSelected(.rock))) { state in
      state.isLoading = true
      state.selectedGenre = .rock
    }

    await store.receive(\.setGenreTrackListResponse) { state in
      state.isLoading = false
      state.searchText = MusicGenre.rock.title
      state.trackList = []
    }
  }

  @Test
  func testPopularGenresAction_Failure() async {
    let store = TestStore(initialState: TrackListFeature.State()) {
      TrackListFeature()
    } withDependencies: { state in
      state.musicService.fetchGenreResponse = { _ in
        throw TestError.popularGenresApiError
      }
    }

    store.exhaustivity = .off

    await store.send(.popularGenresAction(.genreSelected(.rock))) { state in
      state.isLoading = true
      state.selectedGenre = .rock
    }

    await store.receive(\.setGenreTrackListResponse) { state in
      state.isLoading = false
      state.searchText = ""
      state.error = TestError.popularGenresApiError.localizedDescription
      state.trackList = []
    }
  }
}
