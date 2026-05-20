//
//  UmmahHadithResponse.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

// MARK: - API Models

public struct HadithCollectionResponse: Codable {
    public let key: String
    public let name: String
    public let arabicName: String
    public let author: String
    public let reliability: String
    public let totalHadiths: Int

    enum CodingKeys: String, CodingKey {
        case key, name, author, reliability
        case arabicName = "arabic_name"
        case totalHadiths = "total_hadiths"
    }
    
    func toDomain() -> HadithCollectionEntity {
        .init(key: key, name: name, arabicName: arabicName, author: author, reliability: reliability, totalHadiths: totalHadiths)
    }
}

public struct HadithCollectionsResponse: Codable {
    public let collections: [HadithCollectionResponse]
    public let totalHadiths: Int
    public let fetchedAt: String
    public let source: String

    enum CodingKeys: String, CodingKey {
        case collections, source
        case totalHadiths = "total_hadiths"
        case fetchedAt = "fetched_at"
    }
}

public struct HadithItemResponse: Codable {
    public let id: String
    public let collection: String
    public let collectionName: String
    public let hadithnumber: IntOrString
    public let arabic: String
    public let english: String
    public let grade: String?

    enum CodingKeys: String, CodingKey {
        case id, collection, hadithnumber, arabic, english, grade
        case collectionName = "collection_name"
    }
    
    func toDomain() -> HadithEntity {
        .init(id: id, collection: collection, collectionName: collectionName, hadithnumber: hadithnumber.stringValue, arabic: arabic, english: english, grade: grade)
    }
}

public struct BrowseCollectionResponse: Codable {
    public let collection: String
    public let collectionName: String
    public let page: Int
    public let limit: Int
    public let total: Int
    public let totalPages: Int
    public let hadiths: [HadithItemResponse]

    enum CodingKeys: String, CodingKey {
        case collection, page, limit, total, hadiths
        case collectionName = "collection_name"
        case totalPages = "total_pages"
    }
}

public struct SpecificHadithResponse: Codable {
    public let id: String
    public let collection: String
    public let collectionName: String
    public let hadithnumber: IntOrString
    public let arabic: String
    public let english: String
    public let grade: String?

    enum CodingKeys: String, CodingKey {
        case id, collection, hadithnumber, arabic, english, grade
        case collectionName = "collection_name"
    }
    
    func toDomain() -> HadithEntity {
        .init(id: id, collection: collection, collectionName: collectionName, hadithnumber: hadithnumber.stringValue, arabic: arabic, english: english, grade: grade)
    }
}

public struct RandomHadithResponse: Codable {
    public let id: String
    public let collection: String
    public let collectionName: String
    public let hadithnumber: IntOrString
    public let arabic: String
    public let english: String
    public let grade: String?

    enum CodingKeys: String, CodingKey {
        case id, collection, hadithnumber, arabic, english, grade
        case collectionName = "collection_name"
    }
    
    func toDomain() -> HadithEntity {
        .init(id: id, collection: collection, collectionName: collectionName, hadithnumber: hadithnumber.stringValue, arabic: arabic, english: english, grade: grade)
    }
}

public struct SearchHadithsResponse: Codable {
    public let query: String
    public let collection: String?
    public let total: Int
    public let results: [HadithItemResponse]
}

// Helper for Int or String hadithnumber
public enum IntOrString: Codable {
    case int(Int)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .int(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(IntOrString.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for IntOrString"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let x): try container.encode(x)
        case .string(let x): try container.encode(x)
        }
    }
    
    public var stringValue: String {
        switch self {
        case .int(let x): return String(x)
        case .string(let x): return x
        }
    }
}
