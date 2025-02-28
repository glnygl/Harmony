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
    let _state = LockIsolated(State(isPlaying: false, currentURL: ""))
    let player = AVPlayer()
    return Self(
      play: {
        player.play()
        _state.setValue(.init(isPlaying: true, currentURL: _state.currentURL))
      },
      pause: {
        player.pause()
        _state.setValue(.init(isPlaying:false, currentURL: _state.currentURL))
      },
      setVolume: { volume in
        player.volume = Float(volume)
      },
      seek: { time in
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player.seek(to: cmTime)
      },
      currentTime: {
        player.currentItem?.currentTime().seconds ?? 0
      },
      duration: {
        player.currentItem?.duration.seconds ?? 0
      },
      setURL: { urlString in
        guard let url = URL(string: urlString) else {
          throw MusicPlayerError.invalidURL
        }

        if urlString == _state.value.currentURL && player.currentItem != nil {
          return player.currentItem?.duration.seconds ?? 0
        }

        _state.setValue(.init(isPlaying: _state.isPlaying, currentURL: urlString))

        let playerItem = AVPlayerItem(url: url)
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



