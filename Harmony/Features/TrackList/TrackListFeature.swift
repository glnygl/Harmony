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
  @Dependency(\.mainQueue) var mainQueue

  private enum CancelID { case debounce }

  @Reducer(state: .equatable)
  public enum Destination {
    case details(TrackDetailFeature)
    case currentlyPlaying(CurrentlyPlayingBarFeature)
  }

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
    @Presents
    var destination: Destination.State?

  }

  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case destination(PresentationAction<Destination.Action>)
    case listRowSelected(TrackResponse)
    case searchTrackList
    case cancelSearch
    case setTrackListResponse(TaskResult<SearchResponse>)
    case setGenreTrackListResponse(TaskResult<SearchResponse>)
    case popularArtistsAction(PopularArtistsFeature.Action)
    case popularGenresAction(PopularGenreFeature.Action)
  }

  var body: some ReducerOf<Self> {
    BindingReducer()

    Scope(state: \.popularGenresState, action: \.popularGenresAction) { PopularGenreFeature() }
    Scope(state: \.popularArtistsState, action: \.popularArtistsAction) { PopularArtistsFeature() }

    Reduce { state, action in
      switch action {
      case .binding:
          return Effect<TrackListFeature.Action>.none
        case .destination:
          return .none
      case .searchTrackList:
        return performSearch(&state)
      case .listRowSelected(let track):
        state.destination = .details(TrackDetailFeature.State(track: track))
        return .none
      case .setTrackListResponse(.success(let response)):
        updateLoadingState(&state, isLoading: false)
        state.trackList = response.results
        return .none
      case .setTrackListResponse(.failure(let error)):
        updateLoadingState(&state, isLoading: false, error: error.localizedDescription)
        return .none
      case .setGenreTrackListResponse(.success(let response)):
        updateLoadingState(&state, isLoading: false)
        state.searchText = state.selectedGenre?.title ?? ""
        state.trackList = response.results
        return .none
      case .setGenreTrackListResponse(.failure(let error)):
        updateLoadingState(&state, isLoading: false, error: error.localizedDescription)
        return .none
      case .cancelSearch:
        state.trackList = []
        return .none
      case .popularArtistsAction(.artistSelected(let artistName)):
        state.searchText = artistName
        return performSearch(&state)
      case .popularGenresAction(.genreSelected(let genre)):
        return performGenreSearch(&state, genre: genre)
      }
    }
    .ifLet(\.$destination, action: \.destination)

  }

  private func performSearch(_ state: inout State) -> Effect<Action> {
    guard !state.searchText.isEmpty else {
      return .cancel(id: CancelID.debounce)
        .merge(with: .send(.cancelSearch))
    }
    let text = state.searchText
    updateLoadingState(&state, isLoading: true)

    return .run { send in
      await send(.setTrackListResponse(TaskResult { try await searchTrackList(text) }))
    }
    .debounce(id:  CancelID.debounce, for: 1, scheduler: mainQueue)
  }

  private func performGenreSearch(_ state: inout State, genre: MusicGenre) -> Effect<Action> {
    updateLoadingState(&state, isLoading: true)
    state.selectedGenre = genre

    return .run { send in
      await send(.setGenreTrackListResponse(TaskResult { try await getGenreTrackList(genre) }))
    }
  }

  private func searchTrackList(_ searchText: String) async throws -> SearchResponse {
    let request = SearchRequest(searchText: searchText)
    return try await musicService.fetchSearchResponse(request)
  }

  private func getGenreTrackList(_ genre: MusicGenre) async throws -> SearchResponse {
    let request = GenreRequest(genre: genre.rawValue)
    return try await musicService.fetchGenreResponse(request)
  }

  private func updateLoadingState(_ state: inout State, isLoading: Bool, error: String = "") {
    state.isLoading = isLoading
    state.error = error
  }
}
