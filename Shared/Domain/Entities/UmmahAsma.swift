//
//  UmmahAsma.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct AsmaNameEntity: Codable, Identifiable, Equatable {
    public var id: Int { number }
    public let number: Int
    public let name: String?
    public let arabic: String?
    public let transliteration: String
    public let english: String?
    public let meaning: String?
    public let explanation: String?
    public let benefits: String?
}
