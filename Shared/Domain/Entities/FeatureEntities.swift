//
//  QuranReflect.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct ReflectPost: Codable, Identifiable, Equatable {
    public let id: Int
    public let body: String
    public let createdAt: Date
    public let author: ReflectUser
    
    public init(id: Int, body: String, createdAt: Date, author: ReflectUser) {
        self.id = id
        self.body = body
        self.createdAt = createdAt
        self.author = author
    }
}

public struct ReflectUser: Codable, Identifiable, Equatable {
    public let id: Int
    public let name: String
    public let username: String
    public let avatarUrl: URL?
    
    public init(id: Int, name: String, username: String, avatarUrl: URL? = nil) {
        self.id = id
        self.name = name
        self.username = username
        self.avatarUrl = avatarUrl
    }
}

// MARK: - Search
public struct SearchResultItem: Codable, Identifiable, Equatable {
    public let id: String // verseKey usually
    public let verseId: Int
    public let verseKey: String
    public let text: String
    public let translations: [Translation]?
    
    public init(id: String, verseId: Int, verseKey: String, text: String, translations: [Translation]? = nil) {
        self.id = id
        self.verseId = verseId
        self.verseKey = verseKey
        self.text = text
        self.translations = translations
    }
}
