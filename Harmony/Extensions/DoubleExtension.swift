//
//  DoubleExtension.swift
//  Harmony
//
//  Created by Glny Gl on 09/02/2025.
//

extension Double {
  func formatTime() -> String {
    let minutes = Int(self) / 60
    let seconds = Int(self) % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
}
