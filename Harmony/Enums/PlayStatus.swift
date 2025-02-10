//
//  PlayStatus.swift
//  Harmony
//
//  Created by Glny Gl on 10/02/2025.
//

enum PlayStatus {
  case once
  case again
  case forever

  mutating func next() {
      switch self {
      case .once:
          self = .again
      case .again:
          self = .forever
      case .forever:
          self = .once
      }
  }
}
