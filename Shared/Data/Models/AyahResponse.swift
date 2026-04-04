//
//  AyahResponse.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public struct AyahResponse: Codable {
    public let id: String
    public let surahId: String
    public let verseNumber: Int
    public let verseKey: String
    public let text: String?
    
    func toDomain() -> Ayah {
        return Ayah(
            id: id,
            surahId: surahId,
            verseNumber: verseNumber,
            verseKey: verseKey,
            text: text
        )
    }
}
