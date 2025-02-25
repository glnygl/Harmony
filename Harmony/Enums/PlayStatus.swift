//
//  PlayStatus.swift
//  Harmony
//
//  Created by Glny Gl on 10/02/2025.
//

import Sharing

enum PlayStatus: Hashable {
  case once
  case again
  case forever
  
  func next() -> PlayStatus {
    switch self {
      case .once: .again
      case .again: .forever
      case .forever: .once
    }
  }
}

extension SharedKey where Self == InMemoryKey<PlayStatus>.Default {
  static var trackPlayStatus: Self {
    Self[.inMemory("trackPlayStatus"), default: .once]
  }
}
