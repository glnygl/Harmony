//
//  TrackListRowView.swift
//  Harmony
//
//  Created by Glny Gl on 09/02/2025.
//

import SwiftUI
import NukeUI

struct TrackListRowView: View {

  var track: TrackResponse

  var body: some View {
    HStack {
      LazyImage(url:URL(string: track.img ?? "")) { state in
        if let image = state.image {
          image.resizable()
            .frame(width: 64, height: 64)
        } else {
          Rectangle()
            .fill(.gray.opacity(0.2))
            .frame(width: 64, height: 64)
        }
      }
      .clipShape(RoundedRectangle(cornerRadius: 4))

      VStack(alignment: .leading, spacing: 2) {
        Text(track.trackName ?? "")
          .font(.system(size: 16, weight: .semibold))
          .lineLimit(1)

        Text(track.artistName ?? "")
          .font(.system(size: 14))
          .lineLimit(1)
          .foregroundStyle(.gray)
      }
      .padding(.leading, 8)
    }
  }
}

#Preview {
  TrackListRowView(track: TrackResponse(id: 1, img: "", url: "", trackName: "rihanna", artistName: "rihanna", collectionName: ""))
}
