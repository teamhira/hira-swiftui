//
//  QuranicUnit.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct Juz: Codable, Identifiable, Equatable {
    public let id: Int
    public let number: Int
    public let verseMapping: [String: String]
    public let firstVerseId: Int
    public let lastVerseId: Int
    public let versesCount: Int
    
    public init(id: Int, number: Int, verseMapping: [String: String], firstVerseId: Int, lastVerseId: Int, versesCount: Int) {
        self.id = id
        self.number = number
        self.verseMapping = verseMapping
        self.firstVerseId = firstVerseId
        self.lastVerseId = lastVerseId
        self.versesCount = versesCount
    }
}

public struct Hizb: Codable, Identifiable, Equatable {
    public let id: Int
    public let number: Int
    public let verseMapping: [String: String]
    public let firstVerseId: Int
    public let lastVerseId: Int
    public let versesCount: Int
    
    public init(id: Int, number: Int, verseMapping: [String: String], firstVerseId: Int, lastVerseId: Int, versesCount: Int) {
        self.id = id
        self.number = number
        self.verseMapping = verseMapping
        self.firstVerseId = firstVerseId
        self.lastVerseId = lastVerseId
        self.versesCount = versesCount
    }
}

public struct RubElHizb: Codable, Identifiable, Equatable {
    public let id: Int
    public let number: Int
    public let verseMapping: [String: String]
    
    public init(id: Int, number: Int, verseMapping: [String: String]) {
        self.id = id
        self.number = number
        self.verseMapping = verseMapping
    }
}

public struct Manzil: Codable, Identifiable, Equatable {
    public let id: Int
    public let number: Int
    public let verseMapping: [String: String]
    
    public init(id: Int, number: Int, verseMapping: [String: String]) {
        self.id = id
        self.number = number
        self.verseMapping = verseMapping
    }
}

public struct Ruku: Codable, Identifiable, Equatable {
    public let id: Int
    public let number: Int
    public let verseMapping: [String: String]
    
    public init(id: Int, number: Int, verseMapping: [String: String]) {
        self.id = id
        self.number = number
        self.verseMapping = verseMapping
    }
}
