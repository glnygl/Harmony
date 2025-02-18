//
//  PopularArtistsFeatureTest.swift
//  Harmony
//
//  Created by Glny Gl on 18/02/2025.
//

import Testing
import ComposableArchitecture

@testable import Harmony

@MainActor
struct PopularArtistsFeatureTest {

  let store = TestStore(initialState: PopularArtistsFeature.State()) {
    PopularArtistsFeature()
  }

  @Test
  func testArtistsSelectedAction() async {
    await store.send(.artistSelected("Rihanna"))
  }
}
