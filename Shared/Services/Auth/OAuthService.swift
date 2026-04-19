//
//  OAuthService.swift
//  Hira
//
//  Created by Ryuk on 16/04/26.
//

import Foundation
import AuthenticationServices
import Combine

public class OAuthService: NSObject, ASWebAuthenticationPresentationContextProviding {
    private let tokenManager: TokenManager
    private let session: URLSession
    private var authSession: ASWebAuthenticationSession?
    
    public init(tokenManager: TokenManager = .shared, session: URLSession = .shared) {
        self.tokenManager = tokenManager
        self.session = session
    }
    
    /// Starts the OAuth login process.
    public func login(platform: String? = nil) async throws -> UserInfo? {
        print("🔐 [OAuth] Starting login process via Backend...")
        
        let verifier = PKCE.generateCodeVerifier()
        let challenge = PKCE.generateCodeChallenge(from: verifier)
        print("🔑 [OAuth] PKCE Generated.")
        
        let randomState = UUID().uuidString
        let state = platform != nil ? "\(platform!):\(randomState)" : randomState
        
        let authURL = try buildAuthURL(challenge: challenge, state: state)
        let callbackURLScheme = "hira"
        
        return try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(
                url: authURL,
                callbackURLScheme: callbackURLScheme
            ) { [weak self] callbackURL, error in
                guard let self = self else { return }
                self.authSession = nil // Clear reference
                
                if let error = error {
                    print("❌ [OAuth] Session Error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let callbackURL = callbackURL else {
                    print("❌ [OAuth] No callback URL received")
                    continuation.resume(throwing: NetworkError.invalidResponse)
                    return
                }

                print("🌐 [OAuth] Callback URL Received: \(callbackURL.absoluteString)")
                
                guard let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
                      let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
                    print("❌ [OAuth] Failed to extract 'code' from callback. Available query items: \(URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?.queryItems?.map { $0.name }.joined(separator: ", ") ?? "none")")
                    continuation.resume(throwing: NetworkError.invalidResponse)
                    return
                }
                
                print("✅ [OAuth] Code extracted successfully.")
                
                Task {
                    do {
                        let authData = try await self.exchangeOnBackend(code: code, verifier: verifier)
                        print("🔑 [OAuth] Backend exchange successful!")
                        continuation.resume(returning: authData.user)
                    } catch {
                        print("❌ [OAuth] Backend exchange failed: \(error)")
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = true
            self.authSession = session
            session.start()
        }
    }
    
    /// Performs logout by revoking token on the backend and clearing local state.
    public func logout() async {
        print("🚪 [OAuth] Logging out via Backend...")
        
        let refreshToken = tokenManager.getUserRefreshToken()
        
        // 1. Notify Backend
        if let refreshToken = refreshToken {
            let logoutURL = AppConfig.backendURL.appendingPathComponent("api/auth/qf/logout")
            var request = URLRequest(url: logoutURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = ["refreshToken": refreshToken]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            _ = try? await session.data(for: request)
        }
        
        // 2. Clear Local State
        tokenManager.clearUserAuth()
        print("✅ [OAuth] Logout complete.")
    }
    
    /// Checks and refreshes the access token if needed.
    /// Returns true if the session is valid (or successfully refreshed).
    public func refreshAccessToken() async -> Bool {
        print("🔄 [OAuth] Checking for token refresh...")
        
        guard let refreshToken = tokenManager.getUserRefreshToken() else {
            print("❌ [OAuth] No refresh token found.")
            return false
        }
        
        let refreshURL = AppConfig.backendURL.appendingPathComponent("api/auth/qf/refresh")
        var request = URLRequest(url: refreshURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["refreshToken": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("❌ [OAuth] Refresh request failed.")
                return false
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let authData = try decoder.decode(BackendAuthResponse.self, from: data)
            
            tokenManager.saveUserAuth(
                accessToken: authData.accessToken,
                refreshToken: authData.refreshToken,
                expiresIn: authData.expiresIn,
                userInfo: nil // Keep existing user info
            )
            
            print("✅ [OAuth] Token refreshed successfully.")
            return true
        } catch {
            print("❌ [OAuth] Refresh error: \(error)")
            return false
        }
    }
    
    private func buildAuthURL(challenge: String, state: String) throws -> URL {
        var components = URLComponents(url: AppConfig.oauthBaseURL.appendingPathComponent(FoundationEndpoints.oauthAuth), resolvingAgainstBaseURL: false)
        
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: AppConfig.clientID),
            URLQueryItem(name: "redirect_uri", value: AppConfig.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: "openid offline_access bookmark collection user content reading_session activity_day"),
            URLQueryItem(name: "code_challenge", value: challenge),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "prompt", value: "login")
        ]
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        print("🔗 [OAuth] Generated Auth URL: \(url.absoluteString)")
        return url
    }
    
    private func exchangeOnBackend(code: String, verifier: String) async throws -> BackendAuthResponse {
        let exchangeURL = AppConfig.backendURL.appendingPathComponent("api/auth/qf/exchange")
        print("📡 [OAuth] Calling Backend Exchange: \(exchangeURL.absoluteString)")
        
        var request = URLRequest(url: exchangeURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "code": code,
            "codeVerifier": verifier,
            "redirectUri": AppConfig.redirectURI
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            let errorBody = String(data: data, encoding: .utf8) ?? "No error body"
            print("❌ [OAuth] Backend exchange failed [\(httpResponse.statusCode)]: \(errorBody)")
            throw NetworkError.serverError("HTTP \(httpResponse.statusCode)")
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📥 [OAuth] Backend JSON Response: \(jsonString)")
        }
        
        let authData = try decoder.decode(BackendAuthResponse.self, from: data)
        
        // Fallback to idToken if user info is missing or empty
        var finalUser = authData.user
        let isUserEmpty = finalUser == nil || (finalUser?.name == nil && finalUser?.email == nil)
        
        if isUserEmpty, let idToken = authData.idToken {
            print("🔑 [OAuth] User info missing in response, attempting idToken fallback...")
            if let decoded = decodeIDToken(idToken) {
                print("✅ [OAuth] idToken decoded successfully: \(decoded)")
                let firstName = decoded["first_name"] as? String ?? ""
                let lastName = decoded["last_name"] as? String ?? ""
                
                // Try different common JWT claim names for name
                let name = (decoded["name"] as? String) ?? 
                          (decoded["full_name"] as? String) ?? 
                          "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
                
                let email = decoded["email"] as? String
                let sub = decoded["sub"] as? String
                
                finalUser = UserInfo(
                    sub: sub,
                    name: name.isEmpty ? nil : name,
                    email: email,
                    profileImage: nil,
                    id: nil
                )
                print("👤 [OAuth] Fallback user info created: \(finalUser?.name ?? "nil")")
            } else {
                print("❌ [OAuth] Failed to decode idToken")
            }
        }
        
        // Save tokens and user info to TokenManager
        tokenManager.saveUserAuth(
            accessToken: authData.accessToken,
            refreshToken: authData.refreshToken,
            expiresIn: authData.expiresIn,
            userInfo: finalUser
        )
        
        return BackendAuthResponse(
            accessToken: authData.accessToken,
            refreshToken: authData.refreshToken,
            idToken: authData.idToken,
            expiresIn: authData.expiresIn,
            tokenType: authData.tokenType,
            user: finalUser
        )
    }
    
    private func decodeIDToken(_ token: String) -> [String: Any]? {
        let segments = token.components(separatedBy: ".")
        guard segments.count > 1 else {
            print("❌ [OAuth] idToken has less than 2 segments")
            return nil
        }
        
        var base64 = segments[1]
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        while base64.count % 4 != 0 {
            base64.append("=")
        }
        
        guard let data = Data(base64Encoded: base64) else {
            print("❌ [OAuth] Failed to Create Data from base64 string")
            return nil
        }
        
        do {
            return try JSONSerialization.jsonObject(with: data) as? [String: Any]
        } catch {
            print("❌ [OAuth] JSONSerialization error: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - ASWebAuthenticationPresentationContextProviding
    
    @available(iOS, deprecated: 26.0, message: "Use init(windowScene:) instead")
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
            ?? UIApplication.shared.connectedScenes.first as? UIWindowScene
            
        if let window = scene?.windows.first(where: { $0.isKeyWindow }) {
            return window
        }
        
        if let windowScene = scene {
            return UIWindow(windowScene: windowScene)
        }
        
        return UIWindow()
    }
}

// MARK: - Models

private struct BackendAuthResponse: Codable {
    let accessToken: String
    let refreshToken: String?
    let idToken: String?
    let expiresIn: Double
    let tokenType: String
    let user: UserInfo?
}

public struct UserInfo: Codable {
    public let sub: String?
    public let name: String?
    public let email: String?
    public let profileImage: String?
    public let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case sub, name, email, id
        case profileImage = "profile_image"
    }
}
