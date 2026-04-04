//
//  Reciter.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public struct Reciter: Codable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let style: String?
    
    public init(id: String, name: String, style: String? = nil) {
        self.id = id
        self.name = name
        self.style = style
    }
}
