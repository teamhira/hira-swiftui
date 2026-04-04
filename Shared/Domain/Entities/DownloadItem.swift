//
//  DownloadItem.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public enum DownloadStatus: String, Codable {
    case pending
    case downloading
    case completed
    case failed
}

public struct DownloadItem: Codable, Identifiable, Equatable {
    public let id: String
    public let title: String
    public let url: URL
    public let status: DownloadStatus
    public let progress: Float
    
    public init(id: String, title: String, url: URL, status: DownloadStatus = .pending, progress: Float = 0.0) {
        self.id = id
        self.title = title
        self.url = url
        self.status = status
        self.progress = progress
    }
}
