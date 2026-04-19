//
//  QuranReflectAPI.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine

public class QuranReflectAPI {
    private let client: FoundationClient
    
    public init(client: FoundationClient) {
        self.client = client
    }
    
    public func getPost(id: Int) -> AnyPublisher<QuranReflectSingleResponse, Error> {
        return client.request(FoundationEndpoints.quranReflectPost(id: id), method: .get)
    }
    
    public func getFeed(page: Int?) -> AnyPublisher<QuranReflectFeedResponse, Error> {
        var queryItems: [URLQueryItem]?
        if let p = page { queryItems = [URLQueryItem(name: "page", value: String(p))] }
        return client.request(FoundationEndpoints.quranReflectFeed, method: .get, queryItems: queryItems)
    }
}
