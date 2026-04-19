//
//  SearchAPI.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine

public class SearchAPI {
    private let client: FoundationClient
    
    public init(client: FoundationClient) {
        self.client = client
    }
    
    public func searchQuran(query: String, language: String?, page: Int?, size: Int?) -> AnyPublisher<SearchResponse, Error> {
        var queryItems = [URLQueryItem(name: "q", value: query)]
        if let lang = language { queryItems.append(URLQueryItem(name: "language", value: lang)) }
        if let p = page { queryItems.append(URLQueryItem(name: "page", value: String(p))) }
        if let s = size { queryItems.append(URLQueryItem(name: "size", value: String(s))) }
        return client.request(FoundationEndpoints.search, method: .get, queryItems: queryItems)
    }
}
