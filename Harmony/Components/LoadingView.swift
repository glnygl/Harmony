//
//  LoadingView.swift
//  Harmony
//
//  Created by Glny Gl on 10/02/2025.
//

import SwiftUI

struct LoadingView: View {

  @State var activeIndex = 0

  var body: some View {
    HStack {
      ForEach(0..<5) { index in
        RoundedRectangle(cornerRadius: 20)
          .fill(.accent)
          .frame(width: 10, height: activeIndex == index ? 100 : 10)
          .animation(.spring(duration: 0.6), value: activeIndex)
      }
    }
    .onAppear {
      startTimer()
    }
  }

  func startTimer() {
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
      activeIndex = (activeIndex + 1) % 5
    }
  }
}
