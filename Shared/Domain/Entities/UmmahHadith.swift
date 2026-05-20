//
//  UmmahHadith.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct HadithCollectionEntity: Codable, Identifiable, Equatable, Hashable {
    public var id: String { key }
    public let key: String
    public let name: String
    public let arabicName: String
    public let author: String
    public let reliability: String
    public let totalHadiths: Int
}

public struct HadithEntity: Codable, Identifiable, Equatable, Hashable {
    public let id: String
    public let collection: String
    public let collectionName: String
    public let hadithnumber: String
    public let arabic: String
    public let english: String
    public let grade: String?
}
