//
//  ResponseDecoder.swift
//  Harmony
//
//  Created by Glny Gl on 08/02/2025.
//

import Foundation

protocol Decoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

final class ResponseDecoder: Decoder {
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw error
        }
    }
}
