//
//  QuranReflectRepositoryImpl.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine

public class QuranReflectRepositoryImpl: QuranReflectRepository {
    private let api: QuranReflectAPI
    
    public init(api: QuranReflectAPI) {
        self.api = api
    }
    
    public func getPost(id: Int) -> AnyPublisher<PostFeedItemResponse, Error> {
        return api.getPost(id: id).map { (res: QuranReflectSingleResponse) in res.post }.eraseToAnyPublisher()
    }
    
    public func getFeed(page: Int?) -> AnyPublisher<[PostFeedItemResponse], Error> {
        return api.getFeed(page: page).map { (res: QuranReflectFeedResponse) in res.posts }.eraseToAnyPublisher()
    }
}
