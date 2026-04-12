//
//  TranslationResponse.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct TranslationsResponse: Codable {
    public let translations: [TranslationDataResponse]
    public let pagination: PaginationResponse
}

public struct TranslationDataResponse: Codable {
    /// Present when returned as a standalone translation (e.g. /translations/:id/by_chapter)
    public let id: Int?
    public let resourceId: Int?
    public let text: String
    /// Present only on standalone translation endpoints — absent when embedded inside a verse
    public let verseId: Int?
    public let verseKey: String?
    
    enum CodingKeys: String, CodingKey {
        case id, text
        case resourceId = "resource_id"
        case verseId = "verse_id"
        case verseKey = "verse_key"
    }
    
    func toDomain() -> Translation {
        let rid = resourceId ?? id ?? 0
        let vid = verseId ?? 0
        return Translation(
            id: "\(rid)_\(vid)",
            resourceId: rid,
            text: text
        )
    }
}
