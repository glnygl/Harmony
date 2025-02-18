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

  let store = TestStore(initialState: PopularGenreFeature.State()) {
    PopularGenreFeature()
  }

  @Test
  func testGenreSelectedAction() async {
    await store.send(.genreSelected(.dance))
  }
}
