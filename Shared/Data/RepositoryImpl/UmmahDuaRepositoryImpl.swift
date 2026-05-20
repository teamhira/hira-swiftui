//
//  UmmahDuaRepositoryImpl.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public class UmmahDuaRepositoryImpl: UmmahDuaRepository {
    private let api: UmmahDuaAPI
    
    public init(api: UmmahDuaAPI) {
        self.api = api
    }
    
    public func listDuas() -> AnyPublisher<UmmahResponse<ListDuasResponse>, Error> {
        api.listDuas()
    }
    
    public func getCategories() -> AnyPublisher<UmmahResponse<DuaCategoriesResponse>, Error> {
        api.getCategories()
    }
    
    public func getRandomDua() -> AnyPublisher<UmmahResponse<RandomDuaResponse>, Error> {
        api.getRandomDua()
    }
    
    public func searchDuas(query: String, category: String?) -> AnyPublisher<UmmahResponse<SearchDuasResponse>, Error> {
        api.searchDuas(query: query, category: category)
    }
    
    public func getDuasByCategory(id: String) -> AnyPublisher<UmmahResponse<DuasByCategoryResponse>, Error> {
        api.getDuasByCategory(id: id)
    }
    
    public func getSpecificDua(id: Int) -> AnyPublisher<UmmahResponse<DuaItemResponse>, Error> {
        api.getSpecificDua(id: id)
    }
}
