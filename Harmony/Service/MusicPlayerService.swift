//
//  MusicPlayerService.swift
//  Harmony
//
//  Created by Glny Gl on 09/02/2025.
//

import AVFoundation

enum MusicPlayerError: LocalizedError {
  case invalidURL
  case invalidDuration
  case failed(String)
}

struct MusicPlayerService {
  var play: @Sendable () -> Void
  var pause: @Sendable () -> Void
  var setVolume: @Sendable (Double) -> Void
  var seek: @Sendable (Double) -> Void
  var currentTime: @Sendable () -> Double
  var duration: @Sendable () -> Double
  var setURL: @Sendable (String) async throws -> Double
}

extension MusicPlayerService {
  static func live(player: AVPlayer) -> MusicPlayerService {
    return MusicPlayerService(
      play: {
        player.play()
      }, pause: {
        player.pause()
      }, setVolume: { volume in
        player.volume = Float(volume)
      }, seek: { time in
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player.seek(to: cmTime)
      }, currentTime: {
        player.currentItem?.currentTime().seconds ?? 0
      }, duration: {
        player.currentItem?.duration.seconds ?? 0
      }, setURL: { urlString in
        guard let url = URL(string: urlString) else {
          throw MusicPlayerError.invalidURL
        }
        
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        
        return try await withCheckedThrowingContinuation { continuation in
          var observer: NSKeyValueObservation?
          observer = playerItem.observe(\.status, options: [.new]) { item, _ in
            if item.status == .readyToPlay {
              let duration = item.duration.seconds
              if duration.isFinite {
                continuation.resume(returning: duration)
              } else {
                continuation.resume(throwing: MusicPlayerError.invalidDuration)
              }
              observer?.invalidate()
            } else if item.status == .failed {
              continuation.resume(throwing: MusicPlayerError.failed(item.error?.localizedDescription ?? "failed"))
              observer?.invalidate()
            }
          }
        }
      })
  }
}

