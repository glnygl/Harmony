//
//  LoadingModifier.swift
//  Harmony
//
//  Created by Glny Gl on 10/02/2025.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
  let isLoading: Bool

  func body(content: Content) -> some View {
    content
      .disabled(isLoading)
      .blur(radius: isLoading ? 2 : 0)
      .overlay {
        if isLoading {
          LoadingView()
            .edgesIgnoringSafeArea(.all)
            .frame(width: 200, height: 200)
        }
      }
  }
}

extension View {
  func showLoadingView(isLoading: Bool) -> some View {
    ModifiedContent(content: self, modifier: LoadingModifier(isLoading: isLoading))
  }
}
