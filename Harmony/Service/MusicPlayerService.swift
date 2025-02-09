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
  func setMusicURL(_ urlString: String) throws
}

final class MusicPlayerService: MusicPlayerProtocol {
  private var audioPlayer: AVAudioPlayer

  init(audioPlayer: AVAudioPlayer = AVAudioPlayer()) {
    self.audioPlayer = audioPlayer
  }

  func setMusicURL(_ urlString: String) throws {
    guard let url = URL(string: urlString) else { throw "Music url not found"}
    do {
      let data = try Data(contentsOf: url)
      audioPlayer = try AVAudioPlayer(data: data)
      audioPlayer.prepareToPlay()
    } catch {
      throw error
    }
  }

  func play() {
    audioPlayer.play()
  }

  func pause() {
    audioPlayer.pause()
  }

  func setVolume(_ volume: Double) {
    audioPlayer.volume = Float(volume)
  }

  func seek(to time: Double) {
    audioPlayer.currentTime = time
  }

  func currentTime() -> Double {
    return audioPlayer.currentTime
  }

  func duration() -> Double {
    return audioPlayer.duration
  }
}
