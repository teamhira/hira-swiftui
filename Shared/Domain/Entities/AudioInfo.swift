//
//  AudioInfo.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct AudioFile: Codable, Identifiable, Equatable {
    public let id: Int
    public let chapterId: Int
    public let audioUrl: URL
    public let format: String
    public let fileSize: Double
    
    public init(id: Int, chapterId: Int, audioUrl: URL, format: String, fileSize: Double) {
        self.id = id
        self.chapterId = chapterId
        self.audioUrl = audioUrl
        self.format = format
        self.fileSize = fileSize
    }
}

public struct AudioTimestamp: Codable, Equatable {
    public let verseKey: String?
    public let timestampFrom: Int
    public let timestampTo: Int
    public let segments: [[Int]]?
    
    public init(verseKey: String? = nil, timestampFrom: Int, timestampTo: Int, segments: [[Int]]? = nil) {
        self.verseKey = verseKey
        self.timestampFrom = timestampFrom
        self.timestampTo = timestampTo
        self.segments = segments
    }
}
