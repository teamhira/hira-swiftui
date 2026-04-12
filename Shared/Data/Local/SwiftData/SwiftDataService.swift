//
//  SwiftDataService.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import SwiftData

public protocol DatabaseService {
    func saveAyahs(_ ayahs: [Ayah], chapterId: String, language: String, translationIds: [Int])
    func fetchAyahs(chapterId: String, language: String, translationIds: [Int]) -> [Ayah]?
    func clearAyahCache(chapterId: String)
    
    func saveReciters(_ reciters: [RecitationResponse])
    func fetchReciters() -> [RecitationResponse]?
    
    func saveLanguages(_ languages: [LanguageResponse])
    func fetchLanguages() -> [LanguageResponse]?
    
    func saveResources(_ resources: [TranslationResourceResponse], type: String)
    func fetchResources(type: String) -> [TranslationResourceResponse]?
    
    func saveTafsirs(_ resources: [TafsirResponse])
    func fetchTafsirs() -> [TafsirResponse]?
    
    func saveJuzs(_ juzs: [JuzResponse])
    func fetchJuzs() -> [JuzResponse]?
}

public final class SwiftDataService: DatabaseService {
    internal let container: ModelContainer
    internal let context: ModelContext
    
    public init() {
        let schema = Schema([
            AyahEntity.self,
            WordEntity.self,
            TranslationEntity.self,
            ReciterEntity.self,
            LanguageEntity.self,
            ResourceInfoEntity.self,
            JuzEntity.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            self.container = try ModelContainer(for: schema, configurations: [config])
            self.context = ModelContext(container)
        } catch {
            // If initialization fails (probably due to schema mismatch), 
            // try to delete the existing store and all related SQLite files
            let url = config.url
            try? FileManager.default.removeItem(at: url)
            try? FileManager.default.removeItem(at: url.appendingPathExtension("wal"))
            try? FileManager.default.removeItem(at: url.appendingPathExtension("shm"))
            
            do {
                self.container = try ModelContainer(for: schema, configurations: [config])
                self.context = ModelContext(container)
            } catch {
                fatalError("Critical: Failed to initialize SwiftData container even after reset: \(error.localizedDescription)")
            }
        }
    }
}
