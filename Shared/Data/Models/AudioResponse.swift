//
//  AudioResponse.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

extension RecitationResponse {
    func toDomain() -> Reciter {
        return Reciter(
            id: String(id),
            name: reciterName,
            style: style
        )
    }
}

// MARK: - Audio Files
public struct AudioFilesResponse: Codable {
    public let audioFiles: [AudioFileResponse]
    
    enum CodingKeys: String, CodingKey {
        case audioFiles = "audio_files"
    }
}

public struct SingleAudioFileResponse: Codable {
    public let audioFile: AudioFileResponse
    
    enum CodingKeys: String, CodingKey {
        case audioFile = "audio_file"
    }
}

public struct AudioFileResponse: Codable {
    public let id: Int
    public let chapterId: Int
    public let fileSize: Double
    public let format: String
    public let audioUrl: String
    public let timestamps: [AudioTimestampModel]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case chapterId = "chapter_id"
        case fileSize = "file_size"
        case format
        case audioUrl = "audio_url"
        case timestamps
    }
}

public struct AudioTimestampModel: Codable {
    public let verseKey: String
    public let timestampFrom: Double
    public let timestampTo: Double
    public let duration: Double
    public let segments: [[Double]]?
    
    enum CodingKeys: String, CodingKey {
        case verseKey = "verse_key"
        case timestampFrom = "timestamp_from"
        case timestampTo = "timestamp_to"
        case duration
        case segments
    }
}

// MARK: - Timestamp & Lookup
public struct AudioTimestampResponse: Codable {
    public let result: TimestampResult
    
    public struct TimestampResult: Codable {
        public let timestampFrom: Int
        public let timestampTo: Int
        
        enum CodingKeys: String, CodingKey {
            case timestampFrom = "timestamp_from"
            case timestampTo = "timestamp_to"
        }
    }
}

public struct AudioLookupResponse: Codable {
    public let result: LookupResult
    
    public struct LookupResult: Codable {
        public let verseKey: String
        public let timestampFrom: Int
        public let timestampTo: Int
        public let segments: [[Double]]?
        
        enum CodingKeys: String, CodingKey {
            case verseKey = "verse_key"
            case timestampFrom = "timestamp_from"
            case timestampTo = "timestamp_to"
            case segments
        }
    }
}
