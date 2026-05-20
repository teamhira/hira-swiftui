//
//  UmmahDuaResponse.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

// MARK: - API Models

public struct DuaCategoryResponse: Codable {
    public let id: String
    public let name: String
    public let description: String
    public let count: Int?
    
    func toDomain() -> DuaCategoryEntity {
        .init(id: id, name: name, description: description, count: count)
    }
}

public struct DuaItemResponse: Codable {
    public let id: Int
    public let category: String
    public let title: String
    public let arabic: String
    public let transliteration: String
    public let translation: String
    public let source: String?
    public let repeatOnce: Int?
    public let categoryInfo: DuaCategoryResponse?

    enum CodingKeys: String, CodingKey {
        case id, category, title, arabic, transliteration, translation, source
        case repeatOnce = "repeat"
        case categoryInfo = "category_info"
    }
    
    func toDomain() -> DuaEntity {
        .init(id: id, category: category, title: title, arabic: arabic, transliteration: transliteration, translation: translation, source: source, repeatOnce: repeatOnce)
    }
}

public struct ListDuasResponse: Codable {
    public let total: Int
    public let categories: [DuaCategoryResponse]
    public let duas: [DuaItemResponse]
}

public struct RandomDuaResponse: Codable {
    public let id: Int
    public let category: String
    public let title: String
    public let arabic: String
    public let transliteration: String
    public let translation: String
    public let source: String?
    public let repeatOnce: Int?
    public let categoryInfo: DuaCategoryResponse?
    public let totalDuas: Int?

    enum CodingKeys: String, CodingKey {
        case id, category, title, arabic, transliteration, translation, source
        case repeatOnce = "repeat"
        case categoryInfo = "category_info"
        case totalDuas = "total_duas"
    }
    
    func toDomain() -> DuaEntity {
        .init(id: id, category: category, title: title, arabic: arabic, transliteration: transliteration, translation: translation, source: source, repeatOnce: repeatOnce)
    }
}

public struct SearchDuasResponse: Codable {
    public let query: String
    public let category: String?
    public let total: Int
    public let results: [DuaItemResponse]
}

public struct DuaCategoriesResponse: Codable {
    public let total: Int
    public let categories: [DuaCategoryResponse]
}

public struct DuasByCategoryResponse: Codable {
    public let category: DuaCategoryResponse
    public let total: Int
    public let duas: [DuaItemResponse]
}
