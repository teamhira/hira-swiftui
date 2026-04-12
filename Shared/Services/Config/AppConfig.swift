//
//  AppConfig.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public struct AppConfig {
    public static var foundationBaseURL: URL {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "QURAN_FOUNDATION_API_URL") as? String,
              let url = URL(string: urlString) else {
            fatalError("QURAN_FOUNDATION_API_URL is missing or invalid in Info.plist")
        }
        return url
    }
    
    public static var oauthBaseURL: URL {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "QURAN_FOUNDATION_OAUTH_URL") as? String,
              let url = URL(string: urlString) else {
            fatalError("QURAN_FOUNDATION_OAUTH_URL is missing or invalid in Info.plist")
        }
        return url
    }
    
    public static var clientID: String {
        guard let val = Bundle.main.object(forInfoDictionaryKey: "QURAN_FOUNDATION_CLIENT_ID") as? String, !val.isEmpty else {
            fatalError("QURAN_FOUNDATION_CLIENT_ID is missing or empty in Info.plist")
        }
        return val
    }
    
    public static var clientSecret: String {
        guard let val = Bundle.main.object(forInfoDictionaryKey: "QURAN_FOUNDATION_CLIENT_SECRET") as? String, !val.isEmpty else {
            fatalError("QURAN_FOUNDATION_CLIENT_SECRET is missing or empty in Info.plist")
        }
        return val
    }
    
    public struct API {
        public static let timeout: TimeInterval = 30.0
    }
}
