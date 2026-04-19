//
//  SurahInfoResponse.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct SurahInfoResponse: Codable {
    public let chapterInfo: SurahInfoDataResponse?
    
    enum CodingKeys: String, CodingKey {
        case chapterInfo = "chapter_info"
    }
}

public struct SurahInfoDataResponse: Codable {
    public let chapterId: Int
    public let languageName: String
    public let shortText: String?
    public let source: String?
    public let text: String?
    
    enum CodingKeys: String, CodingKey {
        case text, source
        case chapterId = "chapter_id"
        case languageName = "language_name"
        case shortText = "short_text"
    }
    
    func toDomain() -> SurahInfo {
        return SurahInfo(
            chapterId: chapterId,
            languageName: languageName,
            shortText: shortText,
            source: source,
            text: text
        )
    }
}
