//
//  HarmonyApp.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import SwiftUI
import ComposableArchitecture
import SharingGRDB

@main
struct HarmonyApp: App {

  static let store = Store(initialState: AppFeature.State()) { AppFeature() }

  init() {
    prepareDependencies {
      $0.defaultDatabase = .appDatabase
    }
  }

  var body: some Scene {
    WindowGroup {
      AppView(store: Self.store)
    }
  }
}
