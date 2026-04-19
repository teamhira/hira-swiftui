//
//  GetBookmarksAyahsRangeUseCase.swift
//  Hira
//
//  Created by Antigravity on 17/04/26.
//

import Foundation
import Combine

public protocol GetBookmarksAyahsRangeUseCase {
    func execute(chapterNumber: Int, fromAyah: Int, toAyah: Int, mushaf: Int?) -> AnyPublisher<([BookmarkEntity], BookmarkPagination?), Error>
}

public class GetBookmarksAyahsRangeUseCaseImpl: GetBookmarksAyahsRangeUseCase {
    private let repository: BookmarkRepository
    
    public init(repository: BookmarkRepository) {
        self.repository = repository
    }
    
    public func execute(chapterNumber: Int, fromAyah: Int, toAyah: Int, mushaf: Int? = 1) -> AnyPublisher<([BookmarkEntity], BookmarkPagination?), Error> {
        return repository.getBookmarksAyahsRange(chapterNumber: chapterNumber, fromAyah: fromAyah, toAyah: toAyah, mushaf: mushaf)
    }
}
