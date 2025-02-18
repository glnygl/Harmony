//
//  PlayerControlFeatureTest.swift
//  Harmony
//
//  Created by Glny Gl on 18/02/2025.
//

import Testing
import ComposableArchitecture

@testable import Harmony

@MainActor
struct PlayerControlFeatureTest {

  @Test
  func testPlayPauseTappedAction() async {
    let store = TestStore(initialState: PlayerControlFeature.State()) {
      PlayerControlFeature()
    }

    await store.send(.playPauseTapped(true)) { state in
      state.isPlaying = true
    }

    await store.send(.playPauseTapped(false)) { state in
      state.isPlaying = false
    }
  }

  @Test
  func testRewindTappedAction() async {
    let store = TestStore(initialState: PlayerControlFeature.State()) {
      PlayerControlFeature()
    }

    await store.send(.rewindTapped)
  }

  @Test
  func testForwardTappedAction() async {
    let store = TestStore(initialState: PlayerControlFeature.State()) {
      PlayerControlFeature()
    }
    
    await store.send(.forwardTapped)
  }
}
