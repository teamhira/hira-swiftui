//
//  UmmahClient.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public class UmmahClient {
    private let baseURL: URL
    private let session: URLSession
    private let logger = Logger()
    
    public init(
        baseURL: URL = AppConfig.ummahBaseURL,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
        
        print("🚀 UmmahClient initialized:")
        print("   - Base URL: \(baseURL.absoluteString)")
    }
    
    // MARK: - Request Method
    
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
                    do {
                        let data = try await self.executeRequest(
                            path: path, method: method, body: body,
                            queryItems: queryItems, additionalHeaders: additionalHeaders
                        )
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        promise(.success(decoded))
                    } catch {
                        print("❌ UmmahClient: Error for \(path): \(error)")
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
        additionalHeaders: [String: String]? = nil
    ) async throws -> Data {
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
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        additionalHeaders?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        print("🌐 UmmahClient: Requesting [\(method.rawValue)] \(url.absoluteString)")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        print("📥 UmmahClient: Received [\(httpResponse.statusCode)] for \(url.absoluteString)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401 { throw NetworkError.unauthorized }
            if httpResponse.statusCode == 403 { throw NetworkError.forbidden }
            throw NetworkError.serverError("HTTP \(httpResponse.statusCode)")
        }
        
        return data
    }
}
