//
//  AudioAPI.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine

public class AudioAPI {
    private let client: FoundationClient
    
    public init(client: FoundationClient) {
        self.client = client
    }
    
    public func getReciters(language: String?) -> AnyPublisher<RecitationsResponse, Error> {
        var queryItems: [URLQueryItem]?
        if let language = language { queryItems = [URLQueryItem(name: "language", value: language)] }
        return client.request(FoundationEndpoints.recitations, method: .get, queryItems: queryItems)
    }
    
    public func getRecitationInfo(id: Int) -> AnyPublisher<SingleRecitationResponse, Error> {
        return client.request(FoundationEndpoints.recitationInfo(id: id), method: .get)
    }
    
    public func getAudioFiles(recitationId: Int) -> AnyPublisher<AudioFilesResponse, Error> {
        return client.request(FoundationEndpoints.recitationAudioFiles(id: recitationId), method: .get)
    }
    
    public func getAudioByChapter(recitationId: Int, chapterNumber: Int, segments: Bool) -> AnyPublisher<SingleAudioFileResponse, Error> {
        var queryItems: [URLQueryItem] = []
        if segments { queryItems.append(URLQueryItem(name: "segments", value: "true")) }
        return client.request(FoundationEndpoints.audioByChapter(recitationId: recitationId, chapterNumber: chapterNumber), method: .get, queryItems: queryItems)
    }
    
    public func getAudioByAyah(recitationId: Int, verseKey: String) -> AnyPublisher<SingleAudioFileResponse, Error> {
        return client.request(FoundationEndpoints.audioByAyah(recitationId: recitationId, verseKey: verseKey), method: .get)
    }
    
    public func getAudioByJuz(recitationId: Int, juzNumber: Int) -> AnyPublisher<AudioFilesResponse, Error> {
        return client.request(FoundationEndpoints.audioByJuz(recitationId: recitationId, juzNumber: juzNumber), method: .get)
    }
    
    public func getAudioByPage(recitationId: Int, pageNumber: Int) -> AnyPublisher<AudioFilesResponse, Error> {
        return client.request(FoundationEndpoints.audioByPage(recitationId: recitationId, pageNumber: pageNumber), method: .get)
    }
    
    public func getAudioByHizb(recitationId: Int, hizbNumber: Int) -> AnyPublisher<AudioFilesResponse, Error> {
        return client.request(FoundationEndpoints.audioByHizb(recitationId: recitationId, hizbNumber: hizbNumber), method: .get)
    }
    
    public func getAudioByRubElHizb(recitationId: Int, number: Int) -> AnyPublisher<AudioFilesResponse, Error> {
        return client.request(FoundationEndpoints.audioByRubElHizb(recitationId: recitationId, number: number), method: .get)
    }
    
    public func getAudioByManzil(recitationId: Int, number: Int) -> AnyPublisher<AudioFilesResponse, Error> {
        return client.request(FoundationEndpoints.audioByManzil(recitationId: recitationId, number: number), method: .get)
    }
    
    public func getAudioByRuku(recitationId: Int, number: Int) -> AnyPublisher<AudioFilesResponse, Error> {
        return client.request(FoundationEndpoints.audioByRuku(recitationId: recitationId, number: number), method: .get)
    }
    
    public func getChapterReciters() -> AnyPublisher<RecitationsResponse, Error> {
        return client.request("chapter_recitations", method: .get)
    }
    
    public func getChapterReciterAudioFiles(reciterId: Int) -> AnyPublisher<AudioFilesResponse, Error> {
        return client.request(FoundationEndpoints.chapterRecitationAudioFiles(id: reciterId), method: .get)
    }
    
    public func getChapterReciterAudioByChapter(reciterId: Int, chapterNumber: Int) -> AnyPublisher<SingleAudioFileResponse, Error> {
        let queryItems = [URLQueryItem(name: "segments", value: "true")]
        return client.request(FoundationEndpoints.chapterRecitationAudioFile(id: reciterId, chapterId: chapterNumber), method: .get, queryItems: queryItems)
    }
    
    public func getTimestampRange(reciterId: Int, chapterNumber: Int?, verseKey: String?) -> AnyPublisher<AudioTimestampResponse, Error> {
        var queryItems: [URLQueryItem] = []
        if let chapter = chapterNumber { queryItems.append(URLQueryItem(name: "chapter_number", value: String(chapter))) }
        if let key = verseKey { queryItems.append(URLQueryItem(name: "verse_key", value: key)) }
        return client.request(FoundationEndpoints.audioTimestamp(reciterId: reciterId), method: .get, queryItems: queryItems)
    }
    
    public func lookupVerseByTimestamp(reciterId: Int, timestamp: Int) -> AnyPublisher<AudioLookupResponse, Error> {
        let queryItems = [URLQueryItem(name: "timestamp", value: String(timestamp))]
        return client.request(FoundationEndpoints.audioLookup(reciterId: reciterId), method: .get, queryItems: queryItems)
    }
}
