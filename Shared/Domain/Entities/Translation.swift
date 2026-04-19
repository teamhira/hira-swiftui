//
//  Translation.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct Translation: Codable, Identifiable, Equatable, Hashable {
    public let id: String
    public let resourceId: Int
    public let text: String
    public let languageName: String?
    public let authorName: String?
    
    public var idAsInt: Int { Int(id) ?? resourceId }
    
    public init(id: String, resourceId: Int, text: String, languageName: String? = nil, authorName: String? = nil) {
        self.id = id
        self.resourceId = resourceId
        self.text = text
        self.languageName = languageName
        self.authorName = authorName
    }
}

public struct TranslationInfo: Codable, Identifiable, Equatable, Hashable {
    public let id: Int
    public let name: String
    public let authorName: String
    public let slug: String
    public let languageName: String
    
    public init(id: Int, name: String, authorName: String, slug: String, languageName: String) {
        self.id = id
        self.name = name
        self.authorName = authorName
        self.slug = slug
        self.languageName = languageName
    }
}
