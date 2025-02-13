//
//  FavoritesFeature.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import ComposableArchitecture

@Reducer
struct FavoritesFeature {

  @Dependency(\.favoriteService) var favoriteService

  @ObservableState
  struct State: Equatable {
    var trackList: [TrackResponse] =  []
    var error: String = ""
    @Presents var trackDetailState: TrackDetailFeature.State?
  }

  enum Action {
    case fetchFavorites
    case listRowSelected(TrackResponse)
    case showTrackDetail(PresentationAction<TrackDetailFeature.Action>)
    case setTrackListResponse(TaskResult<[TrackResponse]>)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .fetchFavorites:
        return .run { send in
          do {
            let data = try favoriteService.getFavorites(limit: 10, offset: 0)
            await send(.setTrackListResponse(.success(data)))
          } catch {
            await send(.setTrackListResponse(.failure(error)))
          }
        }
      case .setTrackListResponse(.success(let response)):
        state.trackList = response
        return .none
      case .setTrackListResponse(.failure(let error)):
        state.error = error.localizedDescription
        return .none
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
