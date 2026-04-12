//
//  SearchRepositoryImpl.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine

public class SearchRepositoryImpl: SearchRepository {
    private let api: SearchAPI
    
    public init(api: SearchAPI) {
        self.api = api
    }
    
    public func searchQuran(query: String, language: String?, page: Int?, size: Int?) -> AnyPublisher<SearchResultResponse, Error> {
        return api.searchQuran(query: query, language: language, page: page, size: size)
            .map { (res: SearchResponse) in res.search }
            .eraseToAnyPublisher()
    }
}
