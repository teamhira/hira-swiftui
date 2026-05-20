//
//  UmmahDua.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct DuaCategoryEntity: Codable, Identifiable, Equatable, Hashable {
    public let id: String
    public let name: String
    public let description: String
    public let count: Int?
}

public struct DuaEntity: Codable, Identifiable, Equatable, Hashable {
    public let id: Int
    public let category: String
    public let title: String
    public let arabic: String
    public let transliteration: String
    public let translation: String
    public let source: String?
    public let repeatOnce: Int?
}
