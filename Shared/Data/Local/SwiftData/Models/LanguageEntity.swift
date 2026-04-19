//
//  LanguageEntity.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import SwiftData

@Model
public final class LanguageEntity {
    @Attribute(.unique) public var id: Int
    public var name: String
    public var nativeName: String
    public var isoCode: String
    public var direction: String
    public var translationsCount: Int?
    
    public init(id: Int, name: String, nativeName: String, isoCode: String, direction: String, translationsCount: Int? = nil) {
        self.id = id
        self.name = name
        self.nativeName = nativeName
        self.isoCode = isoCode
        self.direction = direction
        self.translationsCount = translationsCount
    }
}
