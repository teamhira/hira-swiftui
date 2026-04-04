//
//  DownloadRepository.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public protocol DownloadRepository {
    func getDownloads() -> AnyPublisher<[DownloadItem], Error>
    func startDownload(item: DownloadItem) -> AnyPublisher<Void, Error>
    func cancelDownload(id: String) -> AnyPublisher<Void, Error>
}
