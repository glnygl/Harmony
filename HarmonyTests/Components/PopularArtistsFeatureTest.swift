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

  @Test
  func testArtistsSelectedAction() async {
    let store = TestStore(initialState: PopularArtistsFeature.State()) {
      PopularArtistsFeature()
    }
    
    await store.send(.artistSelected("Rihanna"))
  }
}
