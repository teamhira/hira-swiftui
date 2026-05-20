//
//  Bookmark.swift
//  Hira
//
//  Created by Ryuk on 17/04/26.
//

import Foundation

public struct BookmarkEntity: Identifiable, Codable, Hashable {
    public let id: String
    public let createdAt: Date
    public let type: BookmarkType
    public let key: Int
    public let verseNumber: Int?
    public let group: String?
    public let isInDefaultCollection: Bool
    public let isReading: Bool
    public let collectionsCount: Int
    
    public enum BookmarkType: String, Codable {
        case ayah, surah, juz, page
    }
    
    public init(id: String, createdAt: Date, type: BookmarkType, key: Int, verseNumber: Int?, group: String?, isInDefaultCollection: Bool, isReading: Bool, collectionsCount: Int) {
        self.id = id
        self.createdAt = createdAt
        self.type = type
        self.key = key
        self.verseNumber = verseNumber
        self.group = group
        self.isInDefaultCollection = isInDefaultCollection
        self.isReading = isReading
        self.collectionsCount = collectionsCount
    }
}

// MARK: - API Models

public struct BookmarksResponse: Codable {
    public let success: Bool
    public let data: [BookmarkModel]?
    public let pagination: BookmarkPagination?
}

public struct BookmarkSingleResponse: Codable {
    public let success: Bool
    public let data: BookmarkModel?
}

public struct BookmarkDeleteResponse: Codable {
    public let success: Bool
    public let data: BookmarkDeleteData
}

public struct BookmarkDeleteData: Codable {
    public let message: String
}

public struct BookmarkModel: Codable {
    public let id: String
    public let createdAt: String
    public let type: String?
    public let key: Int
    public let verseNumber: Int?
    public let group: String?
    public let isInDefaultCollection: Bool
    public let isReading: Bool?
    public let collectionsCount: Int?
    
    public func toEntity() -> BookmarkEntity {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = formatter.date(from: createdAt) ?? Date()
        
        return BookmarkEntity(
            id: id,
            createdAt: date,
            type: BookmarkEntity.BookmarkType(rawValue: type ?? "ayah") ?? .ayah,
            key: key,
            verseNumber: verseNumber,
            group: group,
            isInDefaultCollection: isInDefaultCollection,
            isReading: isReading ?? false,
            collectionsCount: collectionsCount ?? 0
        )
    }
}

public struct BookmarkPagination: Codable {
    public let startCursor: String?
    public let endCursor: String?
    public let hasNextPage: Bool
    public let hasPreviousPage: Bool
}
