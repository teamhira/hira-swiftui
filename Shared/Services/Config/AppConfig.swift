//
//  AppConfig.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public struct AppConfig {
    public static let graphqlURL = URL(string: "http://localhost:8080/graphql")!
    public static let coreBaseURL = URL(string: "http://localhost:8080/api/v1")!
    public static let authBaseURL = URL(string: "http://localhost:8081/api/v1")!
    
    public struct API {
        public static let timeout: TimeInterval = 30.0
    }
}
