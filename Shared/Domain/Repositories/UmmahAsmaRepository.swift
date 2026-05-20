//
//  UmmahAsmaRepository.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public protocol UmmahAsmaRepository {
    func listNames() -> AnyPublisher<UmmahResponse<ListNamesResponse>, Error>
    func getRandomName() -> AnyPublisher<UmmahResponse<SpecificNameResponse>, Error>
    func searchNames(query: String) -> AnyPublisher<UmmahResponse<SearchNamesResponse>, Error>
    func getSpecificName(id: Int) -> AnyPublisher<UmmahResponse<SpecificNameResponse>, Error>
    func getDailyRecitation() -> AnyPublisher<UmmahResponse<DailyRecitationResponse>, Error>
}
