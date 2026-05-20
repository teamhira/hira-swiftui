//
//  UmmahBaseResponse.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct UmmahResponse<T: Codable>: Codable {
    public let success: Bool
    public let service: String
    public let data: T
    public let timestamp: String
    public let apiInfo: UmmahAPIInfo?

    enum CodingKeys: String, CodingKey {
        case success, service, data, timestamp
        case apiInfo = "api_info"
    }
}

public struct UmmahAPIInfo: Codable {
    public let sadaqahJariah: String?
    public let usage: String?
    
    enum CodingKeys: String, CodingKey {
        case sadaqahJariah = "sadaqah_jariah"
        case usage
    }
}
