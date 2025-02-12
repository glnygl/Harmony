//
//  VolumeControlFeature.swift
//  Harmony
//
//  Created by Glny Gl on 12/02/2025.
//

import ComposableArchitecture

@Reducer
struct VolumeControlFeature {
  
  @ObservableState
  struct State: Equatable {
    var volume: Double = 0.5
    var previousVolume: Double = 0.5
  }
  
  enum Action {
    case updateVolume(Double)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .updateVolume(let value):
        state.volume = value
        return .none
      }
    }
  }
}
