//
//  CoreData.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//
import Foundation

public struct CoreData: Codable, Identifiable, Equatable {
    public let id: String
    public let title: String
    public let description: String
    
    public init(id: String, title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
}
