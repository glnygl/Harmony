//
//  MusicGenres.swift
//  Harmony
//
//  Created by Glny Gl on 09/02/2025.
//

import SwiftUI

enum MusicGenres: String {

  case pop
  case rock
  case rap
  case electronic
  case hiphop = "hip-hop"
  case rnb = "r&b"
  case latin
  case jazz
  case blues
  case classical

  var title: String {
    switch self {
    case .pop: return "Pop"
    case .rock: return "Rock"
    case .rap: return "Rap"
    case .electronic: return "Electronic"
    case .hiphop: return "Hip-Hop"
    case .rnb: return "R&B"
    case .latin: return "Latin"
    case .jazz: return "Jazz"
    case .blues: return "Blues"
    case .classical: return "Classical"
    }
  }

  var color: Color {
    switch self {
    case .pop: return Color("popColor")
    case .rock: return Color("rockColor")
    case .rap: return Color("rapColor")
    case .electronic: return Color("electronicColor")
    case .hiphop: return Color("hiphopColor")
    case .rnb: return Color("rnbColor")
    case .latin: return Color("latinColor")
    case .jazz: return Color("jazzColor")
    case .blues: return Color("bluesColor")
    case .classical: return Color("classicalColor")
    }
  }
}
