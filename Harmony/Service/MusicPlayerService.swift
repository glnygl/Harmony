//
//  MusicPlayerService.swift
//  Harmony
//
//  Created by Glny Gl on 09/02/2025.
//

import AVFoundation
import ConcurrencyExtras

enum MusicPlayerError: LocalizedError {
  case invalidURL
  case invalidDuration
  case failed(String)
}

struct MusicPlayerService {

  struct State: Equatable, Sendable {
    var isPlaying: Bool
    var currentURL: String
    var currentTime: Double

    func set(isPlaying: Bool) -> Self {
      .init(isPlaying: isPlaying, currentURL: currentURL, currentTime: currentTime)
    }

    func set(currentTime: Double) -> Self {
      .init(isPlaying: isPlaying, currentURL: currentURL, currentTime: currentTime)
    }

    func set(currentURL: String) -> Self {
      .init(isPlaying: isPlaying, currentURL: currentURL, currentTime: currentTime)
    }
  }

  var play: @Sendable () -> Void
  var pause: @Sendable () -> Void
  var setVolume: @Sendable (Double) -> Void
  var seek: @Sendable (Double) -> Void
  var currentTime: @Sendable () -> Double
  var duration: @Sendable () -> Double
  var setURL: @Sendable (String) async throws -> Double

  var state: @Sendable () -> State
}

extension MusicPlayerService {

  static var liveValue: MusicPlayerService {
    let _state = LockIsolated(State(isPlaying: false, currentURL: "", currentTime: 0))
    let player = AVPlayer()
    return Self(
      play: {
        player.play()
        _state.withValue { $0 = $0.set(isPlaying: true) }
      },
      pause: {
        player.pause()
        _state.withValue { $0 = $0.set(isPlaying: false) }
      },
      setVolume: { volume in
        player.volume = Float(volume)
      },
      seek: { time in
        _state.withValue { $0 = $0.set(currentTime: time) }
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player.seek(to: cmTime)
      },
      currentTime: {
        _state.value.currentTime
      },
      duration: {
        player.currentItem?.duration.seconds ?? 0
      },
      setURL: { urlString in
        guard let url = URL(string: urlString) else {
          throw MusicPlayerError.invalidURL
        }

        let playerItem = AVPlayerItem(url: url)
        if _state.value.isPlaying && urlString == _state.value.currentURL {
          return player.currentItem?.duration.seconds ?? 0
        }
        _state.withValue { $0 = $0.set(currentURL: urlString) }

        player.replaceCurrentItem(with: playerItem)

          return try await withCheckedThrowingContinuation { continuation in
              let observer: LockIsolated<NSKeyValueObservation?> = LockIsolated(nil)
              observer.withValue {
                  $0 = playerItem.observe(\.status, options: [.new]) { item, _ in
                  if item.status == .readyToPlay {
                      let duration = item.duration.seconds
                      if duration.isFinite {
                          continuation.resume(returning: duration)
                      } else {
                          continuation.resume(throwing: MusicPlayerError.invalidDuration)
                      }
                      observer.value?.invalidate()
                  } else if item.status == .failed {
                      continuation.resume(throwing: MusicPlayerError.failed(item.error?.localizedDescription ?? "failed"))
                      observer.value?.invalidate()
                  }
              }
              }
          }
      },

      state: { _state.value }
    )
  }
}



