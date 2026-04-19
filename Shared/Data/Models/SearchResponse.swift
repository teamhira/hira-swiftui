//
//  SearchResponse.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct SearchResponse: Codable {
    public let search: SearchResultResponse
}

public struct SearchResultResponse: Codable {
    public let query: String
    public let totalResults: Int
    public let currentPage: Int
    public let totalPages: Int
    public let results: [SearchItemResponse]
    
    enum CodingKeys: String, CodingKey {
        case query, results
        case totalResults = "total_results"
        case currentPage = "current_page"
        case totalPages = "total_pages"
    }
}

public struct SearchItemResponse: Codable {
    public let verseId: Int
    public let verseKey: String
    public let text: String
    public let translations: [SearchTranslationResponse]?
    
    enum CodingKeys: String, CodingKey {
        case text
        case verseId = "verse_id"
        case verseKey = "verse_key"
        case translations
    }
}

public struct SearchTranslationResponse: Codable {
    public let resourceId: Int
    public let text: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case resourceId = "resource_id"
    }
}
