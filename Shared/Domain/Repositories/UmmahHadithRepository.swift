//
//  UmmahHadithRepository.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public protocol UmmahHadithRepository {
    func listCollections() -> AnyPublisher<UmmahResponse<HadithCollectionsResponse>, Error>
    func browseCollection(collection: String, page: Int?) -> AnyPublisher<UmmahResponse<BrowseCollectionResponse>, Error>
    func getRandomHadith(collection: String?) -> AnyPublisher<UmmahResponse<RandomHadithResponse>, Error>
    func getSpecificHadith(collection: String, number: String) -> AnyPublisher<UmmahResponse<SpecificHadithResponse>, Error>
    func searchHadiths(query: String, collection: String?) -> AnyPublisher<UmmahResponse<SearchHadithsResponse>, Error>
}
