//
//  BookmarkRepositoryImpl.swift
//  Hira
//
//  Created by Antigravity on 17/04/26.
//

import Foundation
import Combine

public class BookmarkRepositoryImpl: BookmarkRepository {
    private let api: BookmarksAPI

    /// Maximum ayah range the API accepts per request.
    private static let maxRangeSize = 30

    public init(api: BookmarksAPI) {
        self.api = api
    }

    public func getBookmarks(
        type: String?,
        isReading: Bool?,
        key: Int?,
        mushaf: Int?,
        first: Int?,
        after: String?
    ) -> AnyPublisher<([BookmarkEntity], BookmarkPagination?), Error> {
        api.getBookmarks(type: type, isReading: isReading, key: key, mushaf: mushaf, first: first, after: after)
            .map { response in
                let entities = response.data?.map { $0.toEntity() } ?? []
                return (entities, response.pagination)
            }
            .eraseToAnyPublisher()
    }

    /// Fetches bookmark state for every ayah in [fromAyah, toAyah], splitting into
    /// chunks of up to 30 ayahs to satisfy the API limit, then merging the results.
    public func getBookmarksAyahsRange(
        chapterNumber: Int,
        fromAyah: Int,
        toAyah: Int,
        mushaf: Int?
    ) -> AnyPublisher<([BookmarkEntity], BookmarkPagination?), Error> {
        let chunks = Self.chunks(from: fromAyah, to: toAyah, size: Self.maxRangeSize)

        // Build one publisher per chunk, merge all, then collect
        let publishers = chunks.map { (start, end) in
            api.getBookmarksAyahsRange(
                chapterNumber: chapterNumber,
                fromAyah: start,
                toAyah: end,
                mushaf: mushaf
            )
            .map { response in response.data?.map { $0.toEntity() } ?? [] }
        }

        return publishers
            .reduce(
                Just([BookmarkEntity]()).setFailureType(to: Error.self).eraseToAnyPublisher()
            ) { accumulated, next in
                accumulated
                    .combineLatest(next.eraseToAnyPublisher())
                    .map { $0 + $1 }
                    .eraseToAnyPublisher()
            }
            .map { entities in (entities, nil as BookmarkPagination?) }
            .eraseToAnyPublisher()
    }

    public func addBookmark(
        type: String,
        key: Int,
        verseNumber: Int?,
        isReading: Bool?,
        mushaf: Int
    ) -> AnyPublisher<BookmarkEntity?, Error> {
        api.addBookmark(type: type, key: key, verseNumber: verseNumber, isReading: isReading, mushaf: mushaf)
            .map { response in response.data?.toEntity() }
            .eraseToAnyPublisher()
    }

    public func deleteBookmark(id: String) -> AnyPublisher<Void, Error> {
        api.deleteBookmark(id: id)
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    // MARK: - Helpers

    /// Splits [from, to] into (start, end) pairs of at most `size` ayahs each.
    private static func chunks(from: Int, to: Int, size: Int) -> [(Int, Int)] {
        guard from <= to else { return [] }
        var result: [(Int, Int)] = []
        var current = from
        while current <= to {
            let end = min(current + size - 1, to)
            result.append((current, end))
            current = end + 1
        }
        return result
    }
}
