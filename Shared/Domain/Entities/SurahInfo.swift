//
//  SurahInfo.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct SurahInfo: Codable, Identifiable, Equatable, Hashable {
    public var id: Int { chapterId }
    public let chapterId: Int
    public let languageName: String
    public let shortText: String?
    public let source: String?
    public let text: String?
    
    public init(chapterId: Int, languageName: String, shortText: String? = nil, source: String? = nil, text: String? = nil) {
        self.chapterId = chapterId
        self.languageName = languageName
        self.shortText = shortText
        self.source = source
        self.text = text
    }
}
