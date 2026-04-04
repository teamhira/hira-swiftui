//
//  QuranRepositoryImpl.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public class QuranRepositoryImpl: QuranRepository {
    private let client: GraphQLClient
    
    public init(client: GraphQLClient) {
        self.client = client
    }
    
    public func getSurahs() -> AnyPublisher<[Surah], Error> {
        let query = """
        query GetSurahs {
            surahs {
                id
                number
                name
                nameArabic
                versesCount
                revelationPlace
            }
        }
        """
        
        struct Response: Codable {
            let surahs: [SurahResponse]
        }
        
        return client.execute(query)
            .map { (res: Response) in res.surahs.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    public func getAyahs(surahId: String) -> AnyPublisher<[Ayah], Error> {
        let query = """
        query GetAyahs($surahId: String!) {
            ayahs(surahId: $surahId) {
                id
                surahId
                verseNumber
                verseKey
                text
            }
        }
        """
        let variables: [String: AnyCodable] = ["surahId": AnyCodable(surahId)]
        
        struct Response: Codable {
            let ayahs: [AyahResponse]
        }
        
        return client.execute(query, variables: variables)
            .map { (res: Response) in res.ayahs.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    public func getJuzs() -> AnyPublisher<[Int], Error> {
        // Simple return as mock for now
        return Just((1...30).map { $0 }).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
