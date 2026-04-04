//
//  DownloadSurahUseCase.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public class DownloadSurahUseCase {
    private let repository: DownloadRepository
    
    public init(repository: DownloadRepository) {
        self.repository = repository
    }
    
    public func execute(surah: Surah, reciter: Reciter) -> AnyPublisher<Void, Error> {
        let downloadItem = DownloadItem(
            id: UUID().uuidString,
            title: "Surah \(surah.name) - \(reciter.name)",
            url: URL(string: "https://example.com/audio/\(surah.number).mp3")!
        )
        return repository.startDownload(item: downloadItem)
    }
}
