//
//  DownloadRepositoryImpl.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public class DownloadRepositoryImpl: DownloadRepository {
    private var downloadItems: [DownloadItem] = []
    private let subject = CurrentValueSubject<[DownloadItem], Error>([])
    
    public init() {}
    
    public func getDownloads() -> AnyPublisher<[DownloadItem], Error> {
        return subject.eraseToAnyPublisher()
    }
    
    public func startDownload(item: DownloadItem) -> AnyPublisher<Void, Error> {
        downloadItems.append(item)
        subject.send(downloadItems)
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    public func cancelDownload(id: String) -> AnyPublisher<Void, Error> {
        downloadItems.removeAll { $0.id == id }
        subject.send(downloadItems)
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
