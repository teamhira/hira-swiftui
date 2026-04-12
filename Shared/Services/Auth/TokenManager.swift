//
//  TokenManager.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public class TokenManager {
    public static let shared = TokenManager()
    private let tokenKey = "auth_token"
    private let expiresKey = "auth_token_expires_at"
    
    private init() {}
    
    public func saveToken(_ token: String, expiresIn: TimeInterval) {
        let expiresAt = Date().addingTimeInterval(expiresIn)
        UserDefaults.standard.set(token, forKey: tokenKey)
        UserDefaults.standard.set(expiresAt.timeIntervalSince1970, forKey: expiresKey)
    }
    
    public func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    public func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: expiresKey)
    }
    
    public var hasToken: Bool {
        return getToken() != nil && isTokenValid
    }
    
    public var isTokenValid: Bool {
        let expiresAt = UserDefaults.standard.double(forKey: expiresKey)
        // Proactive refresh: check if token is valid for at least another 30 seconds
        return expiresAt > Date().addingTimeInterval(30).timeIntervalSince1970
    }
}
