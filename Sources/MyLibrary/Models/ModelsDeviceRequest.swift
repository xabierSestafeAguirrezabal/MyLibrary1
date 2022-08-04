//
//  ModelsDeviceRequest.swift
//  
//
//  Created by Jose F Gómez Arbaizar on 4/8/22.
//


import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

struct ModelsDeviceRequest: Codable, Hashable {

    var id: String
    var properties: ModelsDevicePropertiesRequest
    var rooted: Bool?

    init(id: String, properties: ModelsDevicePropertiesRequest, rooted: Bool? = nil) {
        self.id = id
        self.properties = properties
        self.rooted = rooted
    }

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case properties
        case rooted
    }

    // Encodable protocol methods

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(properties, forKey: .properties)
        try container.encodeIfPresent(rooted, forKey: .rooted)
    }
}
