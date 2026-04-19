//
//  BookmarksAPI.swift
//  Hira
//
//  Created by Antigravity on 17/04/26.
//

import Foundation
import Combine

public class BookmarksAPI {
    private let client: FoundationClient
    
    public init(client: FoundationClient) {
        self.client = client
    }
    
    public func getBookmarks(
        type: String? = nil,
        isReading: Bool? = nil,
        key: Int? = nil,
        mushaf: Int? = nil,
        first: Int? = nil,
        after: String? = nil
    ) -> AnyPublisher<BookmarksResponse, Error> {
        var queryItems: [URLQueryItem] = []
        if let type = type { queryItems.append(URLQueryItem(name: "type", value: type)) }
        if let isReading = isReading { queryItems.append(URLQueryItem(name: "isReading", value: String(isReading))) }
        if let key = key { queryItems.append(URLQueryItem(name: "key", value: String(key))) }
        if let mushaf = mushaf { queryItems.append(URLQueryItem(name: "mushafId", value: String(mushaf))) }
        if let first = first { queryItems.append(URLQueryItem(name: "first", value: String(first))) }
        if let after = after { queryItems.append(URLQueryItem(name: "after", value: after)) }
        
        return client.request(
            FoundationEndpoints.bookmarks,
            method: .get,
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
    }
    
    public func getBookmarksAyahsRange(
        chapterNumber: Int,
        fromAyah: Int,
        toAyah: Int,
        mushaf: Int? = 1
    ) -> AnyPublisher<BookmarksResponse, Error> {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "chapterNumber", value: String(chapterNumber)),
            URLQueryItem(name: "rangeStartAyahNumber", value: String(fromAyah)),
            URLQueryItem(name: "rangeEndAyahNumber", value: String(toAyah))
        ]
        if let mushaf = mushaf { queryItems.append(URLQueryItem(name: "mushafId", value: String(mushaf))) }
        
        return client.request(
            FoundationEndpoints.bookmarksAyahsRange,
            method: .get,
            queryItems: queryItems
        )
    }
    
    public func addBookmark(
        type: String,
        key: Int,
        verseNumber: Int?,
        isReading: Bool? = nil,
        mushaf: Int
    ) -> AnyPublisher<BookmarkSingleResponse, Error> {
        var body: [String: Any] = [
            "type": type,
            "key": key,
            "mushaf": mushaf
        ]
        if let verseNumber = verseNumber { body["verseNumber"] = verseNumber }
        if let isReading = isReading { body["isReading"] = isReading }
        
        guard let data = try? JSONSerialization.data(withJSONObject: body) else {
            return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
        }
        
        return client.request(
            FoundationEndpoints.bookmarks,
            method: .post,
            body: data
        )
    }
    
    public func deleteBookmark(id: String) -> AnyPublisher<BookmarkDeleteResponse, Error> {
        return client.request(
            FoundationEndpoints.bookmark(id: id),
            method: .delete
        )
    }
}
