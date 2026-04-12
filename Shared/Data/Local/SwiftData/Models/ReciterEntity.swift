//
//  ReciterEntity.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import SwiftData

@Model
public final class ReciterEntity {
    @Attribute(.unique) public var id: String
    public var name: String
    public var style: String?
    public var language: String?
    
    public init(id: String, name: String, style: String?, language: String?) {
        self.id = id
        self.name = name
        self.style = style
        self.language = language
    }
}
