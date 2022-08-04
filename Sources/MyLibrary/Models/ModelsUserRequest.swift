//
//  ModelsUserRequest.swift
//  
//
//  Created by Jose F Gómez Arbaizar on 4/8/22.
//


import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

struct ModelsUserRequest: Codable, Hashable {

    var id: String

    init(id: String) {
        self.id = id
    }

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
    }

    // Encodable protocol methods

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
    }
}
