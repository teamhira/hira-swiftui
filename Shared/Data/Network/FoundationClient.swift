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
    }
    
    // MARK: - Reusable Request Methods
    
    public func request<T: Codable>(
        _ path: String,
        method: HTTPMethod = .get,
        body: Data? = nil,
        queryItems: [URLQueryItem]? = nil,
        additionalHeaders: [String: String]? = nil
    ) -> AnyPublisher<T, Error> {
        Deferred {
            Future { promise in
                Task {
                    var responseData: Data?
                    do {
                        let data = try await self.executeRequest(
                            path: path, method: method, body: body,
                            queryItems: queryItems, additionalHeaders: additionalHeaders
                        )
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
        additionalHeaders: [String: String]? = nil,
        retryCount: Int = 0
    ) async throws -> Data {
        let token = await getValidToken()
        
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
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue(token, forHTTPHeaderField: "x-auth-token")
            request.setValue(AppConfig.clientID, forHTTPHeaderField: "x-client-id")
        }
        additionalHeaders?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        print("🌐 FoundationClient: Requesting [\(method.rawValue)] \(url.absoluteString)")
        if let body = body, let bodyString = String(data: body, encoding: .utf8) {
            print("📦 Payload: \(bodyString)")
        }
        logger.debug("🌐 Request: [\(method.rawValue)] \(url.absoluteString)")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ FoundationClient: Invalid response for \(url.absoluteString)")
            throw NetworkError.invalidResponse
        }
        
        print("📥 FoundationClient: Received [\(httpResponse.statusCode)] for \(url.absoluteString)")
        if let responseString = String(data: data, encoding: .utf8) {
            print("🗒️ Response Body: \(responseString)")
        }
        
        if httpResponse.statusCode == 401 && retryCount < 1 && token != nil {
            print("🔑 FoundationClient: Token expired (401). Attempting refresh...")
            return try await executeRequest(
                path: path, method: method, body: body,
                queryItems: queryItems, additionalHeaders: additionalHeaders,
                retryCount: retryCount + 1
            )
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ FoundationClient: Error [\(httpResponse.statusCode)] for \(url.absoluteString)")
            logger.error("❌ Response error: [\(httpResponse.statusCode)] \(url.absoluteString)")
            if httpResponse.statusCode == 401 { 
                tokenManager.clearUserAuth()
                throw NetworkError.unauthorized 
            }
            if httpResponse.statusCode == 403 { throw NetworkError.forbidden }
            throw NetworkError.serverError("HTTP \(httpResponse.statusCode)")
        }
        
        print("✅ FoundationClient: Success [\(httpResponse.statusCode)] for \(url.absoluteString)")
        logger.info("✅ Response success: [\(httpResponse.statusCode)] \(url.absoluteString)")
        return data
    }
    
    // MARK: - Token Management (Stampede Prevention)
    
    private func getValidToken() async -> String? {
        // 1. Priority: User Auth Token
        if let userToken = tokenManager.getUserToken(), tokenManager.isUserTokenValid {
            return userToken
        }
        
        // 2. Refresh if possible
        if let _ = tokenManager.getUserRefreshToken() {
            if let existingTask = tokenRefreshTask {
                return try? await existingTask.value
            }
            
            let refreshTask = Task<String, Error> {
                defer { self.tokenRefreshTask = nil }
                return try await self.refreshUserToken()
            }
            
            self.tokenRefreshTask = refreshTask
            return try? await refreshTask.value
        }
        
        return nil
    }
    
    private func refreshUserToken() async throws -> String {
        guard let refreshToken = tokenManager.getUserRefreshToken() else {
            throw NetworkError.unauthorized
        }
        
        let refreshURL = AppConfig.backendURL.appendingPathComponent("api/auth/qf/refresh")
        var request = URLRequest(url: refreshURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["refreshToken": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        print("🔑 FoundationClient: Refreshing user token via Backend...")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("🔑 FoundationClient: User token refresh via Backend failed")
            tokenManager.clearUserAuth()
            throw NetworkError.refreshTokenFailed
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Use the same response model as OAuthService for consistency
        struct BackendRefreshResponse: Codable {
            let accessToken: String
            let refreshToken: String?
            let expiresIn: Double?
        }
        
        let tokenResponse = try decoder.decode(BackendRefreshResponse.self, from: data)
        
        tokenManager.saveUserAuth(
            accessToken: tokenResponse.accessToken,
            refreshToken: tokenResponse.refreshToken ?? refreshToken,
            expiresIn: tokenResponse.expiresIn ?? 3600
        )
        
        print("🔑 FoundationClient: User token refreshed successfully via Backend")
        return tokenResponse.accessToken
    }
}
