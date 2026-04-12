//
//  SwiftDataService+Resource.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import SwiftData

extension SwiftDataService {
    
    @MainActor
    public func saveLanguages(_ languages: [LanguageResponse]) {
        for lang in languages {
            let entity = LanguageEntity(
                id: lang.id,
                name: lang.name,
                nativeName: lang.nativeName,
                isoCode: lang.isoCode,
                direction: lang.direction ?? "ltr",
                translationsCount: lang.translationsCount
            )
            context.insert(entity)
        }
        try? context.save()
    }
    
    @MainActor
    public func fetchLanguages() -> [LanguageResponse]? {
        let descriptor = FetchDescriptor<LanguageEntity>()
        do {
            let entities = try context.fetch(descriptor)
            return entities.map { entity in
                LanguageResponse(
                    id: entity.id,
                    name: entity.name,
                    isoCode: entity.isoCode,
                    nativeName: entity.nativeName,
                    direction: entity.direction,
                    translationsCount: entity.translationsCount,
                    translatedName: TranslatedName(name: entity.name, languageName: "english")
                )
            }
        } catch {
            return nil
        }
    }
    
    @MainActor
    public func saveResources(_ resources: [TranslationResourceResponse], type: String) {
        for res in resources {
            let entity = ResourceInfoEntity(
                id: res.id,
                name: res.name,
                authorName: res.authorName ?? "",
                slug: res.name, // Using name as slug fallback
                languageName: res.languageName,
                type: type
            )
            context.insert(entity)
        }
        try? context.save()
    }
    
    @MainActor
    public func fetchResources(type: String) -> [TranslationResourceResponse]? {
        let predicate = #Predicate<ResourceInfoEntity> { $0.type == type }
        let descriptor = FetchDescriptor<ResourceInfoEntity>(predicate: predicate)
        do {
            let entities = try context.fetch(descriptor)
            return entities.map { entity in
                TranslationResourceResponse(
                    id: entity.id,
                    name: entity.name,
                    authorName: entity.authorName,
                    languageName: entity.languageName,
                    translatedName: TranslatedName(name: entity.name, languageName: "english")
                )
            }
        } catch {
            return nil
        }
    }
    
    @MainActor
    public func saveTafsirs(_ resources: [TafsirResponse]) {
        saveResources(resources.map { t in
            TranslationResourceResponse(id: t.id, name: t.name, authorName: t.authorName, languageName: t.languageName, translatedName: t.translatedName)
        }, type: "tafsir")
    }
    
    @MainActor
    public func fetchTafsirs() -> [TafsirResponse]? {
        fetchResources(type: "tafsir")?.map { r in
            TafsirResponse(id: r.id, name: r.name, authorName: r.authorName, languageName: r.languageName, translatedName: r.translatedName)
        }
    }
    
    @MainActor
    public func saveReciters(_ reciters: [RecitationResponse]) {
        for res in reciters {
            let entity = ReciterEntity(
                id: String(res.id),
                name: res.reciterName,
                style: res.style ?? "",
                language: res.translatedName.languageName
            )
            context.insert(entity)
        }
        try? context.save()
    }
    
    @MainActor
    public func fetchReciters() -> [RecitationResponse]? {
        let descriptor = FetchDescriptor<ReciterEntity>()
        do {
            let entities = try context.fetch(descriptor)
            return entities.map { entity in
                RecitationResponse(
                    id: Int(entity.id) ?? 0,
                    reciterName: entity.name,
                    style: entity.style,
                    translatedName: TranslatedName(name: entity.name, languageName: "english")
                )
            }
        } catch {
            return nil
        }
    }
}
