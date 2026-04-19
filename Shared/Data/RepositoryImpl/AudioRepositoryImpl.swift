//
//  AudioRepositoryImpl.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine

public class AudioRepositoryImpl: AudioRepository {
    private let api: AudioAPI
    private let database: DatabaseService
    
    public init(api: AudioAPI, database: DatabaseService) {
        self.api = api
        self.database = database
    }
    
    public func getRecitations(language: String?) -> AnyPublisher<[Reciter], Error> {
        if let cached = database.fetchReciters() {
            return Just(cached.map { $0.toDomain() })
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return api.getReciters(language: language)
            .map { [database] (res: RecitationsResponse) in
                let reciters = res.recitations.map { $0.toDomain() }
                database.saveReciters(res.recitations)
                return reciters
            }
            .eraseToAnyPublisher()
    }
    
    public func getRecitationInfo(id: Int) -> AnyPublisher<RecitationResponse, Error> {
        return api.getRecitationInfo(id: id).map { (res: SingleRecitationResponse) in res.recitation }.eraseToAnyPublisher()
    }
    
    public func getAudioFiles(recitationId: Int) -> AnyPublisher<[AudioFileResponse], Error> {
        return api.getAudioFiles(recitationId: recitationId).map { (res: AudioFilesResponse) in res.audioFiles }.eraseToAnyPublisher()
    }
    
    public func getAudioByChapter(recitationId: Int, chapterNumber: Int, segments: Bool) -> AnyPublisher<AudioFileResponse, Error> {
        return api.getAudioByChapter(recitationId: recitationId, chapterNumber: chapterNumber, segments: segments).map { (res: SingleAudioFileResponse) in res.audioFile }.eraseToAnyPublisher()
    }
    
    public func getAudioByAyah(recitationId: Int, verseKey: String) -> AnyPublisher<AudioFileResponse, Error> {
        return api.getAudioByAyah(recitationId: recitationId, verseKey: verseKey).map { (res: SingleAudioFileResponse) in res.audioFile }.eraseToAnyPublisher()
    }
    
    public func getAudioByJuz(recitationId: Int, juzNumber: Int) -> AnyPublisher<[AudioFileResponse], Error> {
        return api.getAudioByJuz(recitationId: recitationId, juzNumber: juzNumber).map { (res: AudioFilesResponse) in res.audioFiles }.eraseToAnyPublisher()
    }
    
    public func getAudioByPage(recitationId: Int, pageNumber: Int) -> AnyPublisher<[AudioFileResponse], Error> {
        return api.getAudioByPage(recitationId: recitationId, pageNumber: pageNumber).map { (res: AudioFilesResponse) in res.audioFiles }.eraseToAnyPublisher()
    }
    
    public func getAudioByHizb(recitationId: Int, hizbNumber: Int) -> AnyPublisher<[AudioFileResponse], Error> {
        return api.getAudioByHizb(recitationId: recitationId, hizbNumber: hizbNumber).map { (res: AudioFilesResponse) in res.audioFiles }.eraseToAnyPublisher()
    }
    
    public func getAudioByRubElHizb(recitationId: Int, number: Int) -> AnyPublisher<[AudioFileResponse], Error> {
        return api.getAudioByRubElHizb(recitationId: recitationId, number: number).map { (res: AudioFilesResponse) in res.audioFiles }.eraseToAnyPublisher()
    }
    
    public func getAudioByManzil(recitationId: Int, number: Int) -> AnyPublisher<[AudioFileResponse], Error> {
        return api.getAudioByManzil(recitationId: recitationId, number: number).map { (res: AudioFilesResponse) in res.audioFiles }.eraseToAnyPublisher()
    }
    
    public func getAudioByRuku(recitationId: Int, number: Int) -> AnyPublisher<[AudioFileResponse], Error> {
        return api.getAudioByRuku(recitationId: recitationId, number: number).map { (res: AudioFilesResponse) in res.audioFiles }.eraseToAnyPublisher()
    }
    
    public func getChapterReciters() -> AnyPublisher<[Reciter], Error> {
        return api.getChapterReciters().map { (res: RecitationsResponse) in res.recitations.map { $0.toDomain() } }.eraseToAnyPublisher()
    }
    
    public func getChapterReciterAudioFiles(reciterId: Int) -> AnyPublisher<[AudioFileResponse], Error> {
        return api.getChapterReciterAudioFiles(reciterId: reciterId).map { (res: AudioFilesResponse) in res.audioFiles }.eraseToAnyPublisher()
    }
    
    public func getChapterReciterAudioByChapter(reciterId: Int, chapterNumber: Int) -> AnyPublisher<AudioFileResponse, Error> {
        return api.getChapterReciterAudioByChapter(reciterId: reciterId, chapterNumber: chapterNumber).map { (res: SingleAudioFileResponse) in res.audioFile }.eraseToAnyPublisher()
    }
    
    public func getTimestampRange(reciterId: Int, chapterNumber: Int?, verseKey: String?) -> AnyPublisher<AudioTimestampResponse.TimestampResult, Error> {
        return api.getTimestampRange(reciterId: reciterId, chapterNumber: chapterNumber, verseKey: verseKey).map { (res: AudioTimestampResponse) in res.result }.eraseToAnyPublisher()
    }
    
    public func lookupVerseByTimestamp(reciterId: Int, timestamp: Int) -> AnyPublisher<AudioLookupResponse.LookupResult, Error> {
        return api.lookupVerseByTimestamp(reciterId: reciterId, timestamp: timestamp).map { (res: AudioLookupResponse) in res.result }.eraseToAnyPublisher()
    }
}
