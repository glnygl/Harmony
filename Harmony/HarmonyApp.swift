//
//  HarmonyApp.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct HarmonyApp: App {

  let store = Store(initialState: AppFeature.State()) { AppFeature() }

  var body: some Scene {
    WindowGroup {
      AppView(store: store)
    }
  }
}
