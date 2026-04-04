//
//  UserResponse.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public struct UserResponse: Codable {
    public let id: String
    public let name: String
    public let email: String
    public let username: String?
    public let role: String?
    
    func toDomain() -> User {
        return User(
            id: id,
            username: username ?? name,
            email: email,
            role: role ?? "USER"
        )
    }
}
