//
//  ChapterInfoResponse.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct ChapterInfoResponse: Codable {
    public let chapterInfo: ChapterInfoData
    
    enum CodingKeys: String, CodingKey {
        case chapterInfo = "chapter_info"
    }
    
    public struct ChapterInfoData: Codable {
        public let id: Int
        public let chapterId: Int
        public let languageName: String
        public let shortText: String
        public let source: String
        public let text: String
        
        enum CodingKeys: String, CodingKey {
            case id, source, text
            case chapterId = "chapter_id"
            case languageName = "language_name"
            case shortText = "short_text"
        }
    }
}
