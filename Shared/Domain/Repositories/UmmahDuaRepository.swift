//
//  UmmahDuaRepository.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public protocol UmmahDuaRepository {
    func listDuas() -> AnyPublisher<UmmahResponse<ListDuasResponse>, Error>
    func getCategories() -> AnyPublisher<UmmahResponse<DuaCategoriesResponse>, Error>
    func getRandomDua() -> AnyPublisher<UmmahResponse<RandomDuaResponse>, Error>
    func searchDuas(query: String, category: String?) -> AnyPublisher<UmmahResponse<SearchDuasResponse>, Error>
    func getDuasByCategory(id: String) -> AnyPublisher<UmmahResponse<DuasByCategoryResponse>, Error>
    func getSpecificDua(id: Int) -> AnyPublisher<UmmahResponse<DuaItemResponse>, Error>
}
