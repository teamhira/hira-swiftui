//
//  SearchRepository.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine

public protocol SearchRepository {
    func searchQuran(query: String, language: String?, page: Int?, size: Int?) -> AnyPublisher<SearchResultResponse, Error>
}
