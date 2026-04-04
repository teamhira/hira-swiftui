//
//  SurahResponse.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public struct SurahResponse: Codable {
    public let id: String
    public let number: Int
    public let name: String
    public let nameArabic: String
    public let nameTranslation: String
    public let versesCount: Int
    public let revelationPlace: String
    
    func toDomain() -> Surah {
        return Surah(
            id: id,
            number: number,
            name: name,
            nameArabic: nameArabic,
            nameTranslation: nameTranslation,
            versesCount: versesCount,
            revelationPlace: revelationPlace
        )
    }
}
