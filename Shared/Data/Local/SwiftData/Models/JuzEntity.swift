//
//  JuzEntity.swift
//  Hira
//
//  Created by Ryuk on 12/04/26.
//

import Foundation
import SwiftData

@Model
public final class JuzEntity {
    @Attribute(.unique) public var number: Int
    public var verseMapping: [String: String]
    public var createdAt: Date
    
    public init(number: Int, verseMapping: [String: String]) {
        self.number = number
        self.verseMapping = verseMapping
        self.createdAt = Date()
    }
}
