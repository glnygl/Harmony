//
//  Request.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

import Foundation

enum HTTPMethod: String, Codable {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}

protocol Request {
  var host: String { get }
  var method: HTTPMethod { get }
  var path: String { get }
  var queryItems: [URLQueryItem]? { get }
}

extension Request {
  var host: String { "itunes.apple.com" }
  var queryItems: [URLQueryItem]? { nil }
}

extension Request {
  
  func asURLRequest() throws -> URLRequest {
    
    var components = URLComponents()
    components.scheme = "https"
    components.host = host
    components.path = path
    components.queryItems = queryItems
    
    guard let url = components.url else { throw NetworkError.invalidURL }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.rawValue
    return urlRequest
  }
  
}


