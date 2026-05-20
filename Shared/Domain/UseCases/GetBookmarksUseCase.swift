//
//  GetBookmarksUseCase.swift
//  Hira
//
//  Created by Ryuk on 17/04/26.
//

import Foundation
import Combine

public protocol GetBookmarksUseCase {
    func execute(type: String?, isReading: Bool?, mushaf: Int?, first: Int?, after: String?) -> AnyPublisher<([BookmarkEntity], BookmarkPagination?), Error>
}

public extension GetBookmarksUseCase {
    func execute(type: String? = nil, isReading: Bool? = nil, mushaf: Int? = 1, first: Int? = 15, after: String? = nil) -> AnyPublisher<([BookmarkEntity], BookmarkPagination?), Error> {
        execute(type: type, isReading: isReading, mushaf: mushaf, first: first, after: after)
    }
}

public class GetBookmarksUseCaseImpl: GetBookmarksUseCase {
    private let repository: BookmarkRepository
    
    public init(repository: BookmarkRepository) {
        self.repository = repository
    }
    
    public func execute(type: String? = nil, isReading: Bool? = nil, mushaf: Int? = 1, first: Int? = 15, after: String? = nil) -> AnyPublisher<([BookmarkEntity], BookmarkPagination?), Error> {
        return repository.getBookmarks(type: type, isReading: isReading, key: nil, mushaf: mushaf, first: first, after: after)
    }
}
