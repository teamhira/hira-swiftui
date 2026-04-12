//
//  TafsirResponse.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct TafsirsResponse: Codable {
    public let tafsirs: [TafsirDataResponse]
    public let pagination: PaginationResponse
}

public struct SingleTafsirResponse: Codable {
    public let tafsir: TafsirDataResponse
}

public struct TafsirDataResponse: Codable {
    public let resourceId: Int
    public let text: String
    public let verseId: Int?
    public let verseKey: String?
    
    enum CodingKeys: String, CodingKey {
        case text
        case resourceId = "resource_id"
        case verseId = "verse_id"
        case verseKey = "verse_key"
    }
    
    func toDomain() -> Tafsir {
        return Tafsir(
            id: "\(resourceId)_\(verseId ?? 0)",
            resourceId: resourceId,
            text: text,
            languageName: nil
        )
    }
}
