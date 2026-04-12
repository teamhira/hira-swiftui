//
//  QuranReflectRepository.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine

public protocol QuranReflectRepository {
    func getPost(id: Int) -> AnyPublisher<PostFeedItemResponse, Error>
    func getFeed(page: Int?) -> AnyPublisher<[PostFeedItemResponse], Error>
}
