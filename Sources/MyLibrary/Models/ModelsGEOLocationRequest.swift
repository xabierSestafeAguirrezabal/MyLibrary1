//
//  ModelsGEOLocationRequest.swift
//  
//
//  Created by Jose F Gómez Arbaizar on 4/8/22.
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

struct ModelsGEOLocationRequest: Codable, Hashable {

    var latitude: Double
    var longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    enum CodingKeys: String, CodingKey, CaseIterable {
        case latitude
        case longitude
    }

    // Encodable protocol methods

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}

