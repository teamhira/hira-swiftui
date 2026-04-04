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
    
    private init() {}
    
    public func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    public func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    public func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    
    public var hasToken: Bool {
        return getToken() != nil
    }
}
