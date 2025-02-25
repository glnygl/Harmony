//
//  PlayStatus.swift
//  Harmony
//
//  Created by Glny Gl on 10/02/2025.
//

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
