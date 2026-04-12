//
//  SwiftDataService+Juz.swift
//  Hira
//
//  Created by Ryuk on 12/04/26.
//

import Foundation
import SwiftData

extension SwiftDataService {
    @MainActor
    public func saveJuzs(_ juzs: [JuzResponse]) {
        // Clear existing to avoid stale structural data
        let deleteDescriptor = FetchDescriptor<JuzEntity>()
        if let existing = try? context.fetch(deleteDescriptor) {
            for entity in existing {
                context.delete(entity)
            }
        }
        
        for juz in juzs {
            let entity = JuzEntity(
                number: juz.juzNumber,
                verseMapping: juz.verseMapping
            )
            context.insert(entity)
        }
        
        try? context.save()
    }
    
    @MainActor
    public func fetchJuzs() -> [JuzResponse]? {
        let descriptor = FetchDescriptor<JuzEntity>(sortBy: [SortDescriptor(\.number)])
        guard let entities = try? context.fetch(descriptor), !entities.isEmpty else {
            return nil
        }
        
        return entities.map { entity in
            JuzResponse(
                id: entity.number,
                juzNumber: entity.number,
                verseMapping: entity.verseMapping,
                firstVerseId: 0,
                lastVerseId: 0,
                versesCount: 0
            )
        }
    }
}
