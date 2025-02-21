//
//  FavoritesFeature.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import ComposableArchitecture
import SharingGRDB

@Reducer
struct FavoritesFeature {
  
  @Dependency(\.favoriteService) var favoriteService
  
  @ObservableState
  struct State: Equatable {
    @SharedReader(.fetch(TrackList(limit: 10, offset: 0), animation: .default))
    var trackList: [TrackResponse] =  []
    var error: String = ""
    @Presents var trackDetailState: TrackDetailFeature.State?
  }

  struct TrackList: FetchKeyRequest {
    let limit: Int
    let offset: Int

    func fetch(_ db: GRDB.Database) throws -> [TrackResponse] {
      let favorites = try FavoriteTrack
        .order(Column("id").desc)
        .limit(limit, offset: offset)
        .fetchAll(db)

      return favorites.map { $0.toTrackResponse() }
    }
  }

  enum Action {
    case fetchFavorites
    case listRowSelected(TrackResponse)
    case showTrackDetail(PresentationAction<TrackDetailFeature.Action>)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .listRowSelected(let track):
        state.trackDetailState = TrackDetailFeature.State(track: track)
        return .none
      case .showTrackDetail(.presented(.dismissButtonTapped)):
        state.trackDetailState = nil
        return .send(.fetchFavorites)
      default:
        return .none
      }
    }
    .ifLet(\.$trackDetailState, action: \.showTrackDetail) { TrackDetailFeature() }
  }

}
