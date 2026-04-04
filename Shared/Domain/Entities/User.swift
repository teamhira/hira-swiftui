//
//  User.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//
import Foundation

public struct User: Codable, Identifiable, Equatable {
    public let id: String
    public let username: String
    public let email: String
    public let role: String
    
    public init(id: String, username: String, email: String, role: String) {
        self.id = id
        self.username = username
        self.email = email
        self.role = role
    }
}
