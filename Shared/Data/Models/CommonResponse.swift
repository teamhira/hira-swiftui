//
//  CommonResponse.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct PaginationResponse: Codable {
    public let perPage: Int
    public let currentPage: Int
    public let nextPage: Int?
    public let totalPages: Int
    public let totalRecords: Int
    
    enum CodingKeys: String, CodingKey {
        case perPage = "per_page"
        case currentPage = "current_page"
        case nextPage = "next_page"
        case totalPages = "total_pages"
        case totalRecords = "total_records"
    }
}

public struct MetaResponse: Codable {
    public let filters: [String: String]?
}
