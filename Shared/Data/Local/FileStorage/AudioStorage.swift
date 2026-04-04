//
//  AudioStorage.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public class AudioStorage {
    private let fileManager = FileManager.default
    
    public init() {}
    
    public func saveAudio(data: Data, filename: String) throws -> URL {
        let directory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = directory.appendingPathComponent(filename)
        try data.write(to: fileURL)
        return fileURL
    }
    
    public func getAudioURL(filename: String) -> URL? {
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        return directory?.appendingPathComponent(filename)
    }
}
