//
//  PopularGenreView.swift
//  Harmony
//
//  Created by Glny Gl on 10/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct PopularGenreView: View {

  var store: StoreOf<PopularGenreFeature>

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      Text("Popular Genres")
        .font(.system(size: 18))
        .fontWeight(.bold)
        .padding(.horizontal)
        .foregroundStyle(.black).opacity(0.6)

      ZStack {
        FlowLayout(spacing: 8) {
          ForEach(store.genres, id: \.self) { genre in
            Text(genre.title)
              .padding(.horizontal, 10)
              .padding(.vertical, 6)
              .overlay(
                RoundedRectangle(cornerRadius: 6)
                  .stroke(.gray, lineWidth: 1)
              )
              .font(.system(size: 16))
              .foregroundColor(.gray)
              .onTapGesture {
                store.send(.genreSelected(genre))
              }
          }
        }
      }.padding(.horizontal, 20)
    }
  }
}
