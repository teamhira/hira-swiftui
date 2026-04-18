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
    
    // User specific keys
    private let userTokenKey = "user_auth_token"
    private let userRefreshTokenKey = "user_refresh_token"
    private let userExpiresKey = "user_auth_token_expires_at"
    private let userNameKey = "user_name"
    private let userEmailKey = "user_email"
    private let userSubKey = "user_sub"
    
    private init() {}
    
    // MARK: - User Auth
    
    public func saveUserAuth(accessToken: String, refreshToken: String?, expiresIn: TimeInterval, userInfo: UserInfo? = nil) {
        let expiresAt = Date().addingTimeInterval(expiresIn)
        UserDefaults.standard.set(accessToken, forKey: userTokenKey)
        UserDefaults.standard.set(refreshToken, forKey: userRefreshTokenKey)
        UserDefaults.standard.set(expiresAt.timeIntervalSince1970, forKey: userExpiresKey)
        
        if let info = userInfo {
            UserDefaults.standard.set(info.name, forKey: userNameKey)
            UserDefaults.standard.set(info.email, forKey: userEmailKey)
            UserDefaults.standard.set(info.sub, forKey: userSubKey)
        }
    }
    
    public func getUserToken() -> String? {
        return UserDefaults.standard.string(forKey: userTokenKey)
    }
    
    public func getUserRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: userRefreshTokenKey)
    }
    
    public func getUserName() -> String? {
        let name = UserDefaults.standard.string(forKey: userNameKey)
        print("👤 [TokenManager] Getting user name: \(name ?? "nil")")
        return name
    }
    
    public func getUserEmail() -> String? {
        let email = UserDefaults.standard.string(forKey: userEmailKey)
        print("📧 [TokenManager] Getting user email: \(email ?? "nil")")
        return email
    }
    
    public func clearUserAuth() {
        UserDefaults.standard.removeObject(forKey: userTokenKey)
        UserDefaults.standard.removeObject(forKey: userRefreshTokenKey)
        UserDefaults.standard.removeObject(forKey: userExpiresKey)
        UserDefaults.standard.removeObject(forKey: userNameKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
        UserDefaults.standard.removeObject(forKey: userSubKey)
    }
    
    public var hasUserToken: Bool {
        return getUserToken() != nil && isUserTokenValid
    }
    
    public var isUserTokenValid: Bool {
        let expiresAt = UserDefaults.standard.double(forKey: userExpiresKey)
        return expiresAt > Date().addingTimeInterval(60).timeIntervalSince1970
    }
    
    // MARK: - Generic
    
    public var hasToken: Bool {
        return hasUserToken
    }
    
    public var isTokenValid: Bool {
        return isUserTokenValid
    }
}
