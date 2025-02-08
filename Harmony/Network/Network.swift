//
//  Network.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

import Foundation

protocol NetworkProtocol {
  func perform<T:Decodable>(_ request: Request, responseType: T.Type) async throws -> T
}

final class Network: NetworkProtocol {

  private let urlSession: URLSession
  private let decoder: Decoder

  init(urlSession: URLSession = URLSession.shared, decoder: Decoder = ResponseDecoder()) {
    self.urlSession = urlSession
    self.decoder = decoder
  }

  func perform<T:Decodable>(_ request: Request, responseType: T.Type) async throws(Error) -> T {
    do {
      let (data, response) = try await urlSession.data(for: request.asURLRequest())
      guard let _ = response as? HTTPURLResponse else {
        throw NetworkError.invalidResponse
      }
      let parsedData = try parseResponse(data: data, responseType: T.self)
      return parsedData
    }
    catch {
      throw error
    }
  }
}

extension Network {
  private func parseResponse<T: Decodable>(data: Data, responseType: T.Type) throws -> T {
    do {
      return try decoder.decode(T.self, from: data)
    } catch {
      throw error
    }
  }
}
