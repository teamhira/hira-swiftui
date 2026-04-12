//
//  FoundationClient.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public class FoundationClient {
    private let baseURL: URL
    private let oauthURL: URL
    private let session: URLSession
    private let tokenManager: TokenManager
    private let logger = Logger()
    
    // Stampede prevention: shared task for token fetching
    private var tokenRefreshTask: Task<String, Error>?
    
    public init(
        baseURL: URL = AppConfig.foundationBaseURL,
        oauthURL: URL = AppConfig.oauthBaseURL,
        session: URLSession = .shared,
        tokenManager: TokenManager = .shared
    ) {
        self.baseURL = baseURL
        self.oauthURL = oauthURL
        self.session = session
        self.tokenManager = tokenManager
        
        print("🚀 FoundationClient initialized:")
        print("   - Base URL: \(baseURL.absoluteString)")
        print("   - OAuth URL: \(oauthURL.absoluteString)")
        print("   - Client ID: \(AppConfig.clientID)")
        print("   - Client Secret: \(AppConfig.clientSecret)")
    }
    
    // MARK: - Reusable Request Methods
    
    public func request<T: Codable>(
        _ path: String,
        method: HTTPMethod = .get,
        body: Data? = nil,
        queryItems: [URLQueryItem]? = nil
    ) -> AnyPublisher<T, Error> {
        Deferred {
            Future { promise in
                Task {
                    var responseData: Data?
                    do {
                        let data = try await self.executeRequest(path: path, method: method, body: body, queryItems: queryItems)
                        responseData = data
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        promise(.success(decoded))
                    } catch {
                        if let data = responseData, let dataString = String(data: data, encoding: .utf8) {
                            print("❌ FoundationClient: Raw JSON on error: \(dataString)")
                        }
                        print("❌ FoundationClient: Decoding/Request error for \(path): \(error)")
                        promise(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Core Execution
    
    private func executeRequest(
        path: String,
        method: HTTPMethod,
        body: Data?,
        queryItems: [URLQueryItem]?,
        retryCount: Int = 0
    ) async throws -> Data {
        let token = try await getValidToken()
        
        var url = baseURL.appendingPathComponent(path)
        if let queryItems = queryItems, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            components.queryItems = queryItems
            if let newURL = components.url {
                url = newURL
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue(token, forHTTPHeaderField: "x-auth-token")
        request.setValue(AppConfig.clientID, forHTTPHeaderField: "x-client-id")
        
        print("🌐 FoundationClient: Requesting [\(method.rawValue)] \(url.absoluteString)")
        logger.debug("🌐 Request: [\(method.rawValue)] \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ FoundationClient: Invalid response for \(url.absoluteString)")
            throw NetworkError.invalidResponse
        }
        
        print("📥 FoundationClient: Received [\(httpResponse.statusCode)] for \(url.absoluteString)")
        if httpResponse.statusCode == 401 && retryCount < 1 {
            print("🔑 FoundationClient: Token expired (401). Retrying...")
            // Token might be expired or rejected. Clear and retry once.
            tokenManager.clearToken()
            return try await executeRequest(path: path, method: method, body: body, queryItems: queryItems, retryCount: retryCount + 1)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ FoundationClient: Error [\(httpResponse.statusCode)] for \(url.absoluteString)")
            logger.error("❌ Response error: [\(httpResponse.statusCode)] \(url.absoluteString)")
            if httpResponse.statusCode == 401 { throw NetworkError.unauthorized }
            if httpResponse.statusCode == 403 { throw NetworkError.forbidden }
            throw NetworkError.serverError("HTTP \(httpResponse.statusCode)")
        }
        
        print("✅ FoundationClient: Success [\(httpResponse.statusCode)] for \(url.absoluteString)")
        logger.info("✅ Response success: [\(httpResponse.statusCode)] \(url.absoluteString)")
        return data
    }
    
    // MARK: - Token Management (Stampede Prevention)
    
    private func getValidToken() async throws -> String {
        if let token = tokenManager.getToken(), tokenManager.isTokenValid {
            return token
        }
        
        // Use shared task to prevent multiple requests for a new token
        if let existingTask = tokenRefreshTask {
            return try await existingTask.value
        }
        
        let refreshTask = Task<String, Error> {
            defer { self.tokenRefreshTask = nil }
            return try await self.fetchNewToken()
        }
        
        self.tokenRefreshTask = refreshTask
        return try await refreshTask.value
    }
    
    private func fetchNewToken() async throws -> String {
        let tokenURL = oauthURL.appendingPathComponent(FoundationEndpoints.oauthToken)
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let credentials = "\(AppConfig.clientID):\(AppConfig.clientSecret)"
        if let base64Credentials = credentials.data(using: .utf8)?.base64EncodedString() {
            request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        }
        
        let bodyComponents = [
            "grant_type": "client_credentials",
            "scope": "content"
        ]
        request.httpBody = bodyComponents.map { "\($0.key)=\($0.value)" }.joined(separator: "&").data(using: .utf8)
        
        print("🔑 FoundationClient: Fetching token from \(tokenURL.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("🔑 FoundationClient: Token fetch failed - Invalid response")
            throw NetworkError.refreshTokenFailed
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            let errorBody = String(data: data, encoding: .utf8) ?? "No error body"
            print("🔑 FoundationClient: Token fetch failed [\(httpResponse.statusCode)] - Body: \(errorBody)")
            throw NetworkError.refreshTokenFailed
        }
        
        print("🔑 FoundationClient: Token fetch successful [200]")
        
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        tokenManager.saveToken(tokenResponse.accessToken, expiresIn: tokenResponse.expiresIn)
        return tokenResponse.accessToken
    }
}

// MARK: - Helper Models

private struct TokenResponse: Codable {
    let accessToken: String
    let expiresIn: Double
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}
