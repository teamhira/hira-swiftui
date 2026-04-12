//
//  SwiftDataService+Reciter.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import SwiftData

extension SwiftDataService {
    
    @MainActor
    public func saveReciters(_ reciters: [Reciter]) {
        for reciter in reciters {
            let entity = ReciterEntity(
                id: reciter.id,
                name: reciter.name,
                style: reciter.style,
                language: nil
            )
            context.insert(entity)
        }
        try? context.save()
    }
    
    @MainActor
    public func fetchReciters() -> [Reciter]? {
        let descriptor = FetchDescriptor<ReciterEntity>()
        do {
            let entities = try context.fetch(descriptor)
            return entities.map { entity in
                Reciter(id: entity.id, name: entity.name, style: entity.style)
            }
        } catch {
            return nil
        }
    }
}
