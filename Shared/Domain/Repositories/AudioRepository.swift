//
//  AudioRepository.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine

public protocol AudioRepository {
    func getRecitations(language: String?) -> AnyPublisher<[Reciter], Error>
    func getRecitationInfo(id: Int) -> AnyPublisher<RecitationResponse, Error>
    func getAudioFiles(recitationId: Int) -> AnyPublisher<[AudioFileResponse], Error>
    func getAudioByChapter(recitationId: Int, chapterNumber: Int, segments: Bool) -> AnyPublisher<AudioFileResponse, Error>
    func getAudioByAyah(recitationId: Int, verseKey: String) -> AnyPublisher<AudioFileResponse, Error>
    func getAudioByJuz(recitationId: Int, juzNumber: Int) -> AnyPublisher<[AudioFileResponse], Error>
    func getAudioByPage(recitationId: Int, pageNumber: Int) -> AnyPublisher<[AudioFileResponse], Error>
    func getAudioByHizb(recitationId: Int, hizbNumber: Int) -> AnyPublisher<[AudioFileResponse], Error>
    func getAudioByRubElHizb(recitationId: Int, number: Int) -> AnyPublisher<[AudioFileResponse], Error>
    func getAudioByManzil(recitationId: Int, number: Int) -> AnyPublisher<[AudioFileResponse], Error>
    func getAudioByRuku(recitationId: Int, number: Int) -> AnyPublisher<[AudioFileResponse], Error>
    
    func getChapterReciters() -> AnyPublisher<[Reciter], Error>
    func getChapterReciterAudioFiles(reciterId: Int) -> AnyPublisher<[AudioFileResponse], Error>
    func getChapterReciterAudioByChapter(reciterId: Int, chapterNumber: Int) -> AnyPublisher<AudioFileResponse, Error>
    
    func getTimestampRange(reciterId: Int, chapterNumber: Int?, verseKey: String?) -> AnyPublisher<AudioTimestampResponse.TimestampResult, Error>
    func lookupVerseByTimestamp(reciterId: Int, timestamp: Int) -> AnyPublisher<AudioLookupResponse.LookupResult, Error>
}
