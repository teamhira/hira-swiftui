//
//  BookmarkRepository.swift
//  Hira
//
//  Created by Ryuk on 17/04/26.
//

import Foundation
import Combine

public protocol BookmarkRepository {
    func getBookmarks(
        type: String?,
        isReading: Bool?,
        key: Int?,
        mushaf: Int?,
        first: Int?,
        after: String?
    ) -> AnyPublisher<([BookmarkEntity], BookmarkPagination?), Error>
    
    func getBookmarksAyahsRange(
        chapterNumber: Int,
        fromAyah: Int,
        toAyah: Int,
        mushaf: Int?
    ) -> AnyPublisher<([BookmarkEntity], BookmarkPagination?), Error>
    
    func addBookmark(
        type: String,
        key: Int,
        verseNumber: Int?,
        isReading: Bool?,
        mushaf: Int
    ) -> AnyPublisher<BookmarkEntity?, Error>
    
    func deleteBookmark(id: String) -> AnyPublisher<Void, Error>
}

public extension BookmarkRepository {
    func getBookmarks(
        type: String? = nil,
        isReading: Bool? = nil,
        key: Int? = nil,
        mushaf: Int? = nil,
        first: Int? = nil,
        after: String? = nil
    ) -> AnyPublisher<([BookmarkEntity], BookmarkPagination?), Error> {
        getBookmarks(type: type, isReading: isReading, key: key, mushaf: mushaf, first: first, after: after)
    }
}
