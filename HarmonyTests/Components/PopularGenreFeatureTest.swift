//
//  PopularGenreFeatureTest.swift
//  Harmony
//
//  Created by Glny Gl on 18/02/2025.
//

import Testing
import ComposableArchitecture

@testable import Harmony

@MainActor
struct PopularGenreFeatureTest {

  @Test
  func testGenreSelectedAction() async {
    let store = TestStore(initialState: PopularGenreFeature.State()) {
      PopularGenreFeature()
    }
    
    await store.send(.genreSelected(.dance))
  }
}
