//
//  VolumeControlFeatureTest.swift
//  Harmony
//
//  Created by Glny Gl on 18/02/2025.
//

import Testing
import ComposableArchitecture

@testable import Harmony

@MainActor
struct VolumeControlFeatureTest {

  @Test
  func testUpdateVolumeAction() async {
    let store = TestStore(initialState: VolumeControlFeature.State()) {
      VolumeControlFeature()
    }

    await store.send(.updateVolume(0.8)) { state in
      state.volume = 0.8
    }
  }
}
