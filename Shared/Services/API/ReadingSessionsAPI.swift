//
//  ReadingSessionsAPI.swift
//  Hira
//
//  Created by Antigravity on 17/04/26.
//

import Foundation
import Combine

public class ReadingSessionsAPI {
    private let client: FoundationClient
    
    public init(client: FoundationClient) {
        self.client = client
    }
    
    public func getReadingSessions(
        first: Int? = nil,
        after: String? = nil,
        last: Int? = nil,
        before: String? = nil
    ) -> AnyPublisher<ReadingSessionsResponse, Error> {
        var queryItems: [URLQueryItem] = []
        if let first = first { queryItems.append(URLQueryItem(name: "first", value: String(first))) }
        if let after = after { queryItems.append(URLQueryItem(name: "after", value: after)) }
        if let last = last { queryItems.append(URLQueryItem(name: "last", value: String(last))) }
        if let before = before { queryItems.append(URLQueryItem(name: "before", value: before)) }
        
        return client.request(
            FoundationEndpoints.readingSessions,
            method: .get,
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
    }
    
    public func addReadingSession(
        chapterNumber: Int,
        verseNumber: Int
    ) -> AnyPublisher<ReadingSessionPostResponse, Error> {
        let body: [String: Any] = [
            "chapterNumber": chapterNumber,
            "verseNumber": verseNumber
        ]
        
        guard let data = try? JSONSerialization.data(withJSONObject: body) else {
            return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
        }
        
        return client.request(
            FoundationEndpoints.readingSessions,
            method: .post,
            body: data
        )
    }
}
