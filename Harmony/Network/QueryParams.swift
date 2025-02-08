//
//  QueryParams.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

import Foundation

protocol QueryParams {
    func toQueryItems() -> [URLQueryItem]
}

extension QueryParams where Self: Encodable {
    func toQueryItems() -> [URLQueryItem] {
        guard let dictionary = try? DictionaryEncoder().encode(self) else { return [] }
        return dictionary.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
    }
}
