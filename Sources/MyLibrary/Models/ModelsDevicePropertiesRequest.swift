//
//  ModelsDevicePropertiesRequest.swift
//  
//
//  Created by Jose F Gómez Arbaizar on 4/8/22.
//


import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif


struct ModelsDevicePropertiesRequest: Codable, Hashable {

    public var cpuAbi: String
    public var manufacturer: String
    public var model: String
    public var os: String
    public var version: String

    init(cpuAbi: String, manufacturer: String, model: String, os: String, version: String) {
        self.cpuAbi = cpuAbi
        self.manufacturer = manufacturer
        self.model = model
        self.os = os
        self.version = version
    }

    enum CodingKeys: String, CodingKey, CaseIterable {
        case cpuAbi = "cpu_abi"
        case manufacturer
        case model
        case os
        case version
    }

    // Encodable protocol methods

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cpuAbi, forKey: .cpuAbi)
        try container.encode(manufacturer, forKey: .manufacturer)
        try container.encode(model, forKey: .model)
        try container.encode(os, forKey: .os)
        try container.encode(version, forKey: .version)
    }
}

