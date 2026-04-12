//
//  WordEntity.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import SwiftData

@Model
public final class WordEntity {
    @Attribute(.unique) public var id: Int
    public var position: Int
    public var text: String?
    public var audioUrl: String?
    public var translation: String?
    public var transliteration: String?
    public var codeV2: String?
    public var pageNumber: Int?
    
    public var textTajweed: String?
    public var ayah: AyahEntity?
    
    public init(id: Int, position: Int, text: String?, textTajweed: String? = nil, audioUrl: String?, translation: String?, transliteration: String?, codeV2: String? = nil, pageNumber: Int? = nil) {
        self.id = id
        self.position = position
        self.text = text
        self.textTajweed = textTajweed
        self.audioUrl = audioUrl
        self.translation = translation
        self.transliteration = transliteration
        self.codeV2 = codeV2
        self.pageNumber = pageNumber
    }
}
