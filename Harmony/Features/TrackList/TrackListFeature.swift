//
//  TrackListFeature.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import ComposableArchitecture

@Reducer
struct TrackListFeature {

  @ObservableState
  struct State: Equatable {
    var searchText: String = ""
    var isLoading: Bool = false
    var isSearchFocused = false
    var error: String = ""
    var trackList: [TrackResponse] = []
    var popularArtistsState = PopularArtistsFeature.State()
    @Presents var trackDetailState: TrackDetailFeature.State?
  }

  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case listRowSelected(TrackResponse)
    case searchTrackList
    case cancelSearch
    case setTrackListResponse(TaskResult<SearchResponse>)
    case showTrackDetail(PresentationAction<TrackDetailFeature.Action>)
    case popularArtistsAction(PopularArtistsFeature.Action)
  }

  @Dependency(\.musicService) var musicService

  private enum CancelID { case debounce }

  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.searchText):
        return .run { send in
          try await Task.sleep(for: .milliseconds(300))
          await send(.searchTrackList)
        }
        .cancellable(id: CancelID.debounce)
      case .searchTrackList:
        guard !state.searchText.isEmpty else {
          return .send(.cancelSearch)
        }
        state.error = ""
        state.isLoading = true
        return .run { [text = state.searchText ]send in
          await send(
            .setTrackListResponse(
              TaskResult {
                try await searchTrackList(text)
              }))
        }
      case .listRowSelected(let track):
        state.trackDetailState = TrackDetailFeature.State(track: track)
        return .none
      case .showTrackDetail(.presented(.dismissButtonTapped)):
        state.trackDetailState = nil
        return .none
      case .setTrackListResponse(.success(let response)):
        state.error = ""
        state.isLoading = false
        state.isSearchFocused = false
        state.trackList = response.results
        return .none
      case .setTrackListResponse(.failure(let error)):
        state.isLoading = false
        state.isSearchFocused = false
        state.error = error.localizedDescription
        return .none
      case .cancelSearch:
         state.trackList = []
         return .none
      case .popularArtistsAction(.artistSelected(let artistName)):
        state.searchText = artistName
        state.isSearchFocused = true
        state.error = ""
        state.isLoading = true
        return .run { [text = state.searchText ]send in
          await send(
            .setTrackListResponse(
              TaskResult {
                try await searchTrackList(text)
              }))
        }
      default:
        return .none
      }
    }

    .ifLet(\.$trackDetailState, action: \.showTrackDetail) { TrackDetailFeature() }

    Scope(state: \.popularArtistsState, action: \.popularArtistsAction) { PopularArtistsFeature() }

// TODO: Deprecated but not causing error
//    Scope(state: \.popularArtistsState, action: /Action.popularArtistsAction) {
//          PopularArtistsFeature()
//      }
  }

  private func searchTrackList(_ searchText: String) async throws -> SearchResponse {
    let request = SearchRequest(searchText: searchText)
    return try await musicService.fetchSearchResponse(request: request)
  }
}
