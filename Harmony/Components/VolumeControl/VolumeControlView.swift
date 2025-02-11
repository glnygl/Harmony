//
//  VolumeControlView.swift
//  Harmony
//
//  Created by Glny Gl on 12/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct VolumeControlView: View {
  
  var store: StoreOf<VolumeControlFeature>
  
  var body: some View {
    HStack {
      Image(systemName: "speaker.fill")
      Slider(
        value: Binding<Double>(
          get: { self.store.state.volume },
          set: { newValue in
            self.store.send(.updateVolume(newValue))
          }
        ), in: 0...1
      )
      Image(systemName: "speaker.wave.3.fill")
    }
  }
}
