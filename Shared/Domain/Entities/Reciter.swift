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
    public let translatedName: String?
    
    public init(id: String, name: String, style: String? = nil, translatedName: String? = nil) {
        self.id = id
        self.name = name
        self.style = style
        self.translatedName = translatedName
    }
}

// MARK: - Preview
extension Reciter {
    public static let preview = Reciter(
        id: "7",
        name: "Mishari Rashid al-`Afasi",
        style: "Murattal",
        translatedName: "Mishari Rashid al-`Afasi"
    )
    
    public static let previewList = [
        preview,
        Reciter(id: "1", name: "AbdulBaset AbdulSamad", style: "Mujawwad")
    ]
}
