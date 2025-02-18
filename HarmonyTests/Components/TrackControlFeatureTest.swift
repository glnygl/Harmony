//
//  TrackControlFeatureTest.swift
//  Harmony
//
//  Created by Glny Gl on 18/02/2025.
//

import Testing
import ComposableArchitecture

@testable import Harmony

@MainActor
struct TrackControlFeatureTest {

  let store = TestStore(initialState: TrackControlFeature.State()) {
    TrackControlFeature()
  }

  @Test
  func testFavoriteButtonTappedAction() async {

    await store.send(.favoriteButtonTapped(true)) { state in
      state.isFavorite = true
    }

    await store.send(.favoriteButtonTapped(false)) { state in
      state.isFavorite = false
    }

  }

  @Test
  func testSetPlayerStatusAction() async {

    await store.send(.setPlayStatus(.once)) { state in
      state.playStatus = .again
    }

    await store.send(.setPlayStatus(.again)) { state in
      state.playStatus = .forever
    }

    await store.send(.setPlayStatus(.forever)) { state in
      state.playStatus = .once
    }

  }

  @Test
  func testMuteVolumeAction() async {

    await store.send(.muteVolume(true)) { state in
      state.isMute = true
    }

    await store.send(.muteVolume(false)) { state in
      state.isMute = false
    }

  }

  @Test
  func testInfoButtonTappedAction() async {
    await store.send(.infoButtonTapped)
  }
}
