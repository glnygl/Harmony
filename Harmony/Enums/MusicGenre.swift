//
//  MusicGenres.swift
//  Harmony
//
//  Created by Glny Gl on 09/02/2025.
//

import SwiftUI

enum MusicGenre: String, CaseIterable {

  case pop
  case rock
  case rap
  case electronic
  case hiphop = "hip-hop"
  case rnb = "r&b"
  case kpop = "k-pop"
  case dance
  case latin
  case country
  case reggae
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
    case .kpop: return  "K-Pop"
    case .dance: return "Dance"
    case .latin: return "Latin"
    case .jazz: return "Jazz"
    case .country: return "Country"
    case .reggae: return "Reggae"
    case .blues: return "Blues"
    case .classical: return "Classical"
    }
  }
}
