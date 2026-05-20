//
//  UmmahAsmaUlHusnaResponse.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

// MARK: - API Models

public struct AsmaUlHusnaItemResponse: Codable {
    public let number: Int
    public let name: String? 
    public let arabic: String?
    public let transliteration: String
    public let english: String? 
    public let meaning: String?
    public let explanation: String?
    public let benefits: String?
    
    func toDomain() -> AsmaNameEntity {
        .init(number: number, name: name, arabic: arabic, transliteration: transliteration, english: english, meaning: meaning, explanation: explanation, benefits: benefits)
    }
}

public struct ListNamesResponse: Codable {
    public let totalCount: Int
    public let names: [AsmaUlHusnaItemResponse]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case names
    }
}

public struct SpecificNameResponse: Codable {
    public let name: AsmaUlHusnaItemResponse
    public let context: AsmaContextModel?
    
    func toDomain() -> AsmaNameEntity {
        name.toDomain()
    }
}

public struct AsmaContextModel: Codable {
    public let position: String
    public let arabicTitle: String
    public let englishTitle: String

    enum CodingKeys: String, CodingKey {
        case position
        case arabicTitle = "arabic_title"
        case englishTitle = "english_title"
    }
}

public struct SearchNamesResponse: Codable {
    public let query: String
    public let count: Int
    public let results: [AsmaUlHusnaItemResponse]
}

public struct DailyRecitationResponse: Codable {
    public let dayNumber: Int
    public let dayName: String
    public let names: [AsmaUlHusnaItemResponse]
    public let count: Int

    enum CodingKeys: String, CodingKey {
        case dayNumber = "day_number"
        case dayName = "day_name"
        case names, count
    }
    
    func toDomain() -> AsmaNameEntity {
        // Return the first name as the featured one
        names.first?.toDomain() ?? .init(number: 1, name: "Ar-Rahman", arabic: "الرَّحْمٰنُ", transliteration: "Ar-Rahman", english: "The Most Merciful", meaning: nil, explanation: nil, benefits: nil)
    }
}
