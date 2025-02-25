//
//  NowPlayingBar.swift
//  Harmony
//
//  Created by Ibrahim Kteish on 21/2/25.
//


import ComposableArchitecture
import SwiftUI
import NukeUI

struct CurrentlyPlayingView: View {

  @Bindable var store: StoreOf<CurrentlyPlayingFeature>
  @State private var averageColor: Color = .white

  var body: some View {
      VStack(spacing: 4) {
          HStack(spacing: 16) {
              LazyImage(url: URL(string: store.trackResponse.img ?? "")) { state in
                  if let image = state.image {
                      image
                          .resizable()
                          .scaledToFill()
                          .frame(width: 48, height: 48)
                          .cornerRadius(4)
                          .onAppear {
                              if let uiColor = state.imageContainer?.image.averageColor {
                                  averageColor = Color(uiColor)
                              }
                          }
                  } else {
                      Rectangle()
                          .fill(.gray.opacity(1))
                          .frame(width: 48, height: 48)
                  }
              }
              VStack(alignment: .leading, spacing: 2) {
                  Text(store.trackResponse.trackName ?? "")
                      .font(.headline)
                      .foregroundColor(.white)
                      .lineLimit(1)
                  Text(store.trackResponse.artistName ?? "")
                      .font(.subheadline)
                      .foregroundColor(.white.opacity(0.8))
                      .lineLimit(1)
              }
              
              Spacer()
              
              Button(action: {
                  store.send(.playButtonTapped)
              }) {
                  Image(systemName: store.isPlaying ? "pause.fill" : "play.fill")
                      .font(.title2)
                      .foregroundColor(.white)
                      .padding(.leading, 8)
              }
              .padding(.trailing, 10)
          }
          
          HiddenThumbSlider(
              value: self.$store.currentTime,
              range: 0...max(0.001, store.duration),
              accentColor: .white,
              isUserInteractionEnabled: false
          )
          .frame(height: 4)
          .padding(.horizontal, 0)
      }
    .padding(.horizontal, 4)
    .padding(.vertical, 4)
    .background(averageColor)
    .cornerRadius(8)
    .shadow(radius: 2)
    .padding(.horizontal, 4)
    .onTapGesture {
      self.store.send(.viewTapped)
    }
    .onReceive(Timer.publish(every: 1, on: .main, in: .default).autoconnect()) { _ in
      if store.isPlaying {
        store.send(.updateTime)
      }
    }
  }
}

struct HiddenThumbSlider: UIViewRepresentable {
    var value: Binding<Double>
    var range: ClosedRange<Double>
    var accentColor: UIColor
    var isUserInteractionEnabled: Bool = false

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.minimumValue = Float(range.lowerBound)
        slider.maximumValue = Float(range.upperBound)
        slider.value = Float(value.wrappedValue)
        // Hide the thumb by setting an empty image
        slider.setThumbImage(UIImage(), for: .normal)
        slider.setThumbImage(UIImage(), for: .highlighted)
        slider.isUserInteractionEnabled = isUserInteractionEnabled
        slider.minimumTrackTintColor = accentColor
        slider.maximumTrackTintColor = UIColor(white: 1.0, alpha: 0.3)
        
        if isUserInteractionEnabled {
            slider.addTarget(
                context.coordinator,
                action: #selector(Coordinator.valueChanged(_:)),
                for: .valueChanged
            )
        }
        
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value.wrappedValue)
        uiView.minimumValue = Float(range.lowerBound)
        uiView.maximumValue = Float(range.upperBound)
        uiView.minimumTrackTintColor = accentColor
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: HiddenThumbSlider
        
        init(_ parent: HiddenThumbSlider) {
            self.parent = parent
        }
        
      @MainActor
      @objc func valueChanged(_ sender: UISlider) {
            parent.value.wrappedValue = Double(sender.value)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
  CurrentlyPlayingView(
    store: .init(
      initialState: CurrentlyPlayingFeature.State.init(
        trackResponse: .init(
          id: 1,
          img: "img",
          url: "url",
          trackName: "Name",
          artistName: "Artist Name",
          collectionName: "collection",
          infoURL: "infoURL"
        ),
        isPlaying: true
      ),
      reducer: { CurrentlyPlayingFeature()
      }
    )
  )
}

