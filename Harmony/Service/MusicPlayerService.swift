//
//  MusicPlayerService.swift
//  Harmony
//
//  Created by Glny Gl on 09/02/2025.
//

import AVFoundation

extension String: @retroactive Error {}

protocol MusicPlayerProtocol {
  func play()
  func pause()
  func setVolume(_ volume: Double)
  func seek(to time: Double)
  func currentTime() -> Double
  func duration() -> Double
  func setURL(_ urlString: String) async throws -> Double
}

final class MusicPlayerService: MusicPlayerProtocol {
  private var player: AVPlayer
  private var playerItem: AVPlayerItem?

  init(player: AVPlayer = AVPlayer()) {
    self.player = player
  }

  func setURL(_ urlString: String) async throws -> Double {
    guard let url = URL(string: urlString) else {
      throw NSError(domain: "MusicPlayerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Music URL not found"])
    }

    let playerItem = AVPlayerItem(url: url)
    self.playerItem = playerItem
    player.replaceCurrentItem(with: playerItem)

    return try await withCheckedThrowingContinuation { continuation in
      var observer: NSKeyValueObservation?
      observer = playerItem.observe(\.status, options: [.new]) { item, _ in
        if item.status == .readyToPlay {
          let duration = item.duration.seconds
          if duration.isFinite {
            continuation.resume(returning: duration)
          } else {
            continuation.resume(throwing: NSError(domain: "MusicPlayerError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Duration is not available"]))
          }
          observer?.invalidate()
        } else if item.status == .failed {
          continuation.resume(throwing: NSError(domain: "MusicPlayerError", code: 3, userInfo: [NSLocalizedDescriptionKey: item.error?.localizedDescription ?? "Unknown error"]))
          observer?.invalidate()
        }
      }
    }
  }

  func play() {
    player.play()
  }

  func pause() {
    player.pause()
  }

  func setVolume(_ volume: Double) {
    player.volume = Float(volume)
  }

  func seek(to time: Double) {
    let cmTime = CMTime(seconds: time, preferredTimescale: 600)
    player.seek(to: cmTime)
  }

  func currentTime() -> Double {
    return player.currentItem?.currentTime().seconds ?? 0
  }

  func duration() -> Double {
    return player.currentItem?.duration.seconds ?? 0
  }
}

