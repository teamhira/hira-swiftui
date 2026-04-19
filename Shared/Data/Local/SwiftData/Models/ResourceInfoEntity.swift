//
//  ResourceInfoEntity.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import SwiftData

@Model
public final class ResourceInfoEntity {
    @Attribute(.unique) public var id: Int
    public var name: String
    public var authorName: String
    public var slug: String
    public var languageName: String
    public var type: String // "tafsir" or "translation"
    
    public init(id: Int, name: String, authorName: String, slug: String, languageName: String, type: String) {
        self.id = id
        self.name = name
        self.authorName = authorName
        self.slug = slug
        self.languageName = languageName
        self.type = type
    }
}
