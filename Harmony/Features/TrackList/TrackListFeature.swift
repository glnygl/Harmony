//
//  TrackListFeature.swift
//  Harmony
//
//  Created by Glny Gl on 07/02/2025.
//

import ComposableArchitecture

@Reducer
struct TrackListFeature {

  @Dependency(\.musicService) var musicService

  private enum CancelID { case debounce }

  @ObservableState
  struct State: Equatable {
    var searchText: String = ""
    var selectedGenre: MusicGenre? = nil
    var isLoading: Bool = false
    var error: String = ""
    var trackList: [TrackResponse] = []
    var grammyTrackList: [TrackResponse] = GrammyWinner.tracks
    var popularArtistsState = PopularArtistsFeature.State()
    var popularGenresState = PopularGenreFeature.State()
    @Presents var trackDetailState: TrackDetailFeature.State?
  }

  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case listRowSelected(TrackResponse)
    case searchTrackList
    case cancelSearch
    case setTrackListResponse(TaskResult<SearchResponse>)
    case setGenreTrackListResponse(TaskResult<SearchResponse>)
    case showTrackDetail(PresentationAction<TrackDetailFeature.Action>)
    case popularArtistsAction(PopularArtistsFeature.Action)
    case popularGenresAction(PopularGenreFeature.Action)
  }

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
        state.trackList = response.results
        return .none
      case .setTrackListResponse(.failure(let error)):
        state.isLoading = false
        state.error = error.localizedDescription
        return .none
      case .setGenreTrackListResponse(.success(let response)):
        state.error = ""
        state.isLoading = false
        state.searchText = state.selectedGenre?.title ?? ""
        state.trackList = response.results
        return .none
      case .setGenreTrackListResponse(.failure(let error)):
        state.isLoading = false
        state.error = error.localizedDescription
        return .none
      case .cancelSearch:
         state.trackList = []
         return .none
      case .popularArtistsAction(.artistSelected(let artistName)):
        state.searchText = artistName
        state.error = ""
        state.isLoading = true
        return .run { [text = state.searchText ]send in
          await send(
            .setTrackListResponse(
              TaskResult {
                try await searchTrackList(text)
              }))
        }
      case .popularGenresAction(.genreSelected(let genre)):
        state.error = ""
        state.isLoading = true
        state.selectedGenre = genre
        return .run { send in
          await send(
            .setGenreTrackListResponse(
              TaskResult {
                try await getGenreTrackList(genre)
              }))
        }
      default:
        return .none
      }
    }

    .ifLet(\.$trackDetailState, action: \.showTrackDetail) { TrackDetailFeature() }

    Scope(state: \.popularGenresState, action: \.popularGenresAction) { PopularGenreFeature() }
    Scope(state: \.popularArtistsState, action: \.popularArtistsAction) { PopularArtistsFeature() }

  }

  private func searchTrackList(_ searchText: String) async throws -> SearchResponse {
    let request = SearchRequest(searchText: searchText)
    return try await musicService.fetchSearchResponse(request: request)
  }

  private func getGenreTrackList(_ genre: MusicGenre) async throws -> SearchResponse {
    let request = GenreRequest(genre: genre.rawValue)
    return try await musicService.fetchGenreResponse(request: request)
  }
}
