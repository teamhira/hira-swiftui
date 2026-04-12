//
//  SwiftDataService+Ayah.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import SwiftData

extension SwiftDataService {
    
    @MainActor
    public func saveAyahs(_ ayahs: [Ayah], chapterId: String, language: String, translationIds: [Int]) {
        for ayah in ayahs {
            let ayahId = "\(chapterId):\(ayah.verseNumber)"
            let entity = AyahEntity(
                id: ayahId,
                surahId: chapterId,
                verseNumber: ayah.verseNumber,
                verseKey: ayah.verseKey,
                text: ayah.text,
                juzNumber: ayah.juzNumber,
                pageNumber: ayah.pageNumber,
                language: language,
                translationIds: translationIds.sorted()
            )
            entity.verseAudio = ayah.audio
            
            context.insert(entity)
            
            // Words
            if let words = ayah.words {
                for word in words {
                    let wordEntity = WordEntity(
                        id: word.id,
                        position: word.position,
                        text: word.text,
                        textTajweed: word.textTajweed,
                        audioUrl: word.audioUrl,
                        translation: word.translation,
                        transliteration: word.transliteration,
                        codeV2: word.codeV2,
                        pageNumber: word.pageNumber
                    )
                    wordEntity.ayah = entity
                    context.insert(wordEntity)
                }
            }
            
            // Translations
            if let translations = ayah.translations {
                for trans in translations {
                    let transEntity = TranslationEntity(
                        id: "\(trans.resourceId):\(ayah.id)",
                        resourceId: trans.resourceId,
                        text: trans.text,
                        languageName: trans.languageName,
                        authorName: trans.authorName
                    )
                    transEntity.ayah = entity
                    context.insert(transEntity)
                }
            }
        }
        
        try? context.save()
    }
    
    @MainActor
    public func fetchAyahs(chapterId: String, language: String, translationIds: [Int]) -> [Ayah]? {
        let sortedIdsString = translationIds.sorted().map(String.init).joined(separator: ",")
        let predicate = #Predicate<AyahEntity> { entity in
            entity.surahId == chapterId && 
            entity.language == language && 
            entity.translationIdsString == sortedIdsString
        }
        
        var descriptor = FetchDescriptor<AyahEntity>(predicate: predicate)
        descriptor.sortBy = [SortDescriptor(\.verseNumber)]
        
        do {
            let entities = try context.fetch(descriptor)
            
            let domainAyahs = entities.map { entity in
                let words = entity.words?.map { wordEntity in
                    Word(
                        id: wordEntity.id,
                        position: wordEntity.position,
                        text: wordEntity.text,
                        textTajweed: wordEntity.textTajweed,
                        audioUrl: wordEntity.audioUrl,
                        translation: wordEntity.translation,
                        transliteration: wordEntity.transliteration,
                        codeV2: wordEntity.codeV2,
                        pageNumber: wordEntity.pageNumber
                    )
                }.sorted { $0.position < $1.position }
                
                let translations = entity.translations?.map { transEntity in
                    Translation(
                        id: transEntity.id,
                        resourceId: transEntity.resourceId,
                        text: transEntity.text,
                        languageName: transEntity.languageName,
                        authorName: transEntity.authorName
                    )
                }
                
                return Ayah(
                    id: entity.id,
                    surahId: entity.surahId,
                    verseNumber: entity.verseNumber,
                    verseKey: entity.verseKey,
                    text: entity.text,
                    juzNumber: entity.juzNumber,
                    pageNumber: entity.pageNumber,
                    words: words,
                    translations: translations,
                    audio: entity.verseAudio
                )
            }
            
            return domainAyahs.isEmpty ? nil : domainAyahs
        } catch {
            return nil
        }
    }
    
    @MainActor
    public func clearAyahCache(chapterId: String) {
        let predicate = #Predicate<AyahEntity> { $0.surahId == chapterId }
        try? context.delete(model: AyahEntity.self, where: predicate)
    }
}
