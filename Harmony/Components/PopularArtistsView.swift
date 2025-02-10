//
//  PopularArtistsView.swift
//  Harmony
//
//  Created by Glny Gl on 09/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct Artist: Equatable {
  let id: Int
  let name: String
  let image: String
}

struct PopularArtistsView: View {

  var store: StoreOf<PopularArtistsFeature>

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("Popular Artists")
        .font(.title3)
        .fontWeight(.bold)
        .padding(.horizontal)
        .foregroundStyle(.gray)
        .underline()

      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 4) {
          ForEach(store.artists, id: \.id) { artist in
            PopularArtistsRowView(imageName: artist.image)
              .onTapGesture {
                store.send(.artistSelected(artist.name))
              }
          }
        }
        .frame(height: 120)
        .padding(.horizontal, 8)
      }
      Spacer()
    }
  }
}

struct PopularArtistsRowView: View {
  let imageName: String

  var body: some View {
    ZStack {
      Image(imageName)
        .resizable()
        .frame(width: 120, height: 120)
    }
  }
}
