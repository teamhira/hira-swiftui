//
//  Ayah.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public struct Ayah: Codable, Identifiable, Equatable {
    public let id: String
    public let surahId: String
    public let verseNumber: Int
    public let verseKey: String
    public let text: String?
    
    public init(id: String, surahId: String, verseNumber: Int, verseKey: String, text: String? = nil) {
        self.id = id
        self.surahId = surahId
        self.verseNumber = verseNumber
        self.verseKey = verseKey
        self.text = text
    }
}
