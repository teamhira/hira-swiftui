//
//  TranslationEntity.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import SwiftData

@Model
public final class TranslationEntity {
    @Attribute(.unique) public var id: String // resourceId:verseId
    public var resourceId: Int
    public var text: String
    public var languageName: String?
    public var authorName: String?
    
    public var ayah: AyahEntity?
    
    public init(id: String, resourceId: Int, text: String, languageName: String?, authorName: String?) {
        self.id = id
        self.resourceId = resourceId
        self.text = text
        self.languageName = languageName
        self.authorName = authorName
    }
}
