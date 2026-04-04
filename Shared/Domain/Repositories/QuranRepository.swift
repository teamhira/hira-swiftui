//
//  QuranRepository.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public protocol QuranRepository {
    func getSurahs() -> AnyPublisher<[Surah], Error>
    func getAyahs(surahId: String) -> AnyPublisher<[Ayah], Error>
    func getJuzs() -> AnyPublisher<[Int], Error>
}
