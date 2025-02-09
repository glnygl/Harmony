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
    var error: String?
    var trackList: [TrackResponse] = []
    @Presents var trackDetailState: TrackDetailFeature.State?
  }

  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case listRowSelected(TrackResponse)
    case showTrackDetail(PresentationAction<TrackDetailFeature.Action>)
    case searchTrackList
    case setTrackListResponse(TaskResult<SearchResponse>)
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
          state.trackList = []
          return .none
        }
        state.error = nil
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
        state.error = nil
        state.isLoading = false
        state.trackList = response.results
        return .none
      case .setTrackListResponse(.failure(let error)):
        state.isLoading = false
        state.error = error.localizedDescription
        return .none
      default:
        return .none
      }
    }
    .ifLet(\.$trackDetailState, action: \.showTrackDetail) {
      TrackDetailFeature()
    }
  }

  private func searchTrackList(_ searchText: String) async throws -> SearchResponse {
    let request = SearchRequest(searchText: searchText)
    return try await musicService.fetchSearchResponse(request: request)
  }
}
