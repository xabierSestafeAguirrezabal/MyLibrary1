//
//  ModelsTransactionRequest.swift
//  
//
//  Created by Jose F Gómez Arbaizar on 4/8/22.
//


import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

struct ModelsTransactionRequest: Codable, Hashable {

    var device: ModelsDeviceRequest
    var electromagneticLocation: String?
    var extraData: String
    var geoLocation: ModelsGEOLocationRequest
    var id: String
    var user: ModelsUserRequest
    var connected_bssid: String?

    init(device: ModelsDeviceRequest, electromagneticLocation: String?, extraData:
         String, geoLocation: ModelsGEOLocationRequest, id: String, user: ModelsUserRequest, connected_bssid: String) {
        self.device = device
        self.electromagneticLocation = electromagneticLocation
        self.extraData = extraData
        self.geoLocation = geoLocation
        self.id = id
        self.user = user
        self.connected_bssid = connected_bssid
    }

    enum CodingKeys: String, CodingKey, CaseIterable {
        case device
        case electromagneticLocation = "electromagnetic_location"
        case extraData = "extra_data"
        case geoLocation = "geo_location"
        case id
        case user
        case connected_bssid
    }

    // Encodable protocol methods

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(device, forKey: .device)
        try container.encodeIfPresent(electromagneticLocation, forKey: .electromagneticLocation)
        try container.encodeIfPresent(extraData, forKey: .extraData)
        try container.encode(geoLocation, forKey: .geoLocation)
        try container.encode(id, forKey: .id)
        try container.encode(user, forKey: .user)
        try container.encode(connected_bssid, forKey: .connected_bssid)
    }
}

