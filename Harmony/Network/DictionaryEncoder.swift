//
//  DictionaryEncoder.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

import Foundation

protocol Encoder {
  func encode<T: Encodable>(_ value: T) throws -> [String: Any]
}

final class DictionaryEncoder: Encoder {
  private let encoder: JSONEncoder
  
  init(encoder: JSONEncoder = JSONEncoder()) {
    self.encoder = encoder
  }
  
  func encode<T: Encodable>(_ value: T) throws -> [String: Any] {
    let data = try encoder.encode(value)
    guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
      throw NetworkError.jsonEncodeError
    }
    return jsonObject
  }
}
