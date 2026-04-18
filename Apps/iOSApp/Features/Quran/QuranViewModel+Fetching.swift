//
//  QuranViewModel+Fetching.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI
import Combine

extension QuranViewModel {
    public func ayahs(for surah: Surah) -> [QuranAyah] {
        if let cached = ayahCache[surah.number] {
            return cached
        }
        
        return (1...surah.versesCount).map { i in
            QuranAyah(
                surahNumber: surah.number,
                number: i,
                textArabic: "", 
                textLatin: "",
                translation: "",
                isPlaceholder: true
            )
        }
    }
    
    public func ayahsForPage(_ page: Int) -> [QuranAyah] {
        if let cached = pageCache[page] {
            return cached
        }
        return []
    }
    
    public func isAyahsLoading(forPage page: Int) -> Bool {
        return isLoadingPage[page] ?? false
    }
    
    public func isAyahsLoading(for surah: Surah) -> Bool {
        return isLoadingAyahs[surah.number] ?? false
    }
    
    public func fetchPage(_ page: Int) {
        guard !isAyahsLoading(forPage: page), pageCache[page] == nil else { return }
        
        let language = selectedLanguageCode
        isLoadingPage[page] = true
        
        let audioParam = showWordAudio ? nil : selectedReciterId
        getAyahsByPageUseCase.execute(
            pageNumber: page,
            language: language,
            translations: [selectedTranslationId],
            words: true,
            audio: audioParam
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard let self else { return }
            self.isLoadingPage[page] = false
        } receiveValue: { [weak self] ayahs in
            guard let self else { return }
            let models = ayahs.map { QuranAyah(from: $0) }
            self.pageCache[page] = models
            self.lastCacheUpdate = Date()
        }
        .store(in: &cancellables)
    }
    
    public func groupedAyahsForPage(_ page: Int) -> [(surahNumber: Int, ayahs: [QuranAyah])] {
        let ayahs = ayahsForPage(page)
        let dict = Dictionary(grouping: ayahs, by: { $0.surahNumber })
        return dict.keys.sorted().map { surahNumber in
            let sortedAyahs = (dict[surahNumber] ?? []).sorted(by: { $0.number < $1.number })
            return (surahNumber: surahNumber, ayahs: sortedAyahs)
        }
    }
    
    public func fetchAyahs(for surah: Surah, language: String = "en") {
        let needsTajweed = showTajweed
        let hasTajweed = ayahCache[surah.number]?.contains(where: { !($0.words.first?.textTajweed ?? "").isEmpty }) ?? false
        
        if ayahCache[surah.number] != nil && needsTajweed && !hasTajweed {
            ayahCache[surah.number] = nil
        }

        guard ayahCache[surah.number] == nil,
              isLoadingAyahs[surah.number] != true else { return }
        
        let resolvedLanguage = switch language {
        case "id": "id"
        case "ms": "ms"
        case "ar": "ar"
        default: "en"
        }
        
        _loadAyahPage(surah: surah, language: resolvedLanguage)
    }

    private func _loadAyahPage(surah: Surah, language: String) {
        isLoadingAyahs[surah.number] = true
        
        let audioParam = showWordAudio ? nil : selectedReciterId
        getAyahsByChapterUseCase.execute(
            chapterId: String(surah.number),
            language: language,
            page: 1,
            perPage: 300,
            words: true,
            audio: audioParam
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard let self else { return }
            self.isLoadingAyahs[surah.number] = false
        } receiveValue: { [weak self] fetchedAyahs in
            guard let self else { return }
            let mapped = fetchedAyahs.map { QuranAyah(from: $0) }
            self.ayahCache[surah.number] = mapped
            self.lastCacheUpdate = Date()
            
            if let active = self.activeAyah, active.surahNumber == surah.number {
                if let real = mapped.first(where: { $0.number == active.number }) {
                    self.activeAyah = real
                }
            } else if self.activeAyah == nil {
                self.activeAyah = mapped.first
            }
        }
        .store(in: &cancellables)
    }
    
    public func fetchJuzs() {
        guard juzList.isEmpty, !isFetchingJuzs else { return }
        
        isFetchingJuzs = true
        getJuzListUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isFetchingJuzs = false
            } receiveValue: { [weak self] juzs in
                guard let self else { return }
                let uniqueMap = juzs.reduce(into: [Int: JuzResponse]()) { dict, juz in
                    dict[juz.juzNumber] = juz
                }
                let sortedJuzs = uniqueMap.values.sorted(by: { $0.juzNumber < $1.juzNumber })
                
                self.juzList = sortedJuzs.map { juz in
                    JuzProgress(
                        number: juz.juzNumber,
                        surahRange: self.formatJuzRange(juz.verseMapping),
                        progress: 0.0,
                        verseMapping: juz.verseMapping
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    private func formatJuzRange(_ mapping: [String: String]) -> String {
        let surahIds = mapping.keys.compactMap { Int($0) }.sorted()
        guard let firstId = surahIds.first, let lastId = surahIds.last else { return "Unknown" }
        
        let firstSurah = surahs.first(where: { $0.number == firstId })?.name ?? "Surah \(firstId)"
        let lastSurah = surahs.first(where: { $0.number == lastId })?.name ?? "Surah \(lastId)"
        
        return firstId == lastId ? firstSurah : "\(firstSurah) - \(lastSurah)"
    }
    
    public func fetchSurahInfo(id: Int, language: String) {
        getSurahInfoUseCase.execute(id: String(id), language: language)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] info in
                self?.surahInfo = info
            }
            .store(in: &cancellables)
    }
    
    public func fetchSurahs(language: String = "en") {
        self.isLoading = true
        self.errorMessage = nil
        
        getSurahListUseCase.execute(language: language)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
            } receiveValue: { [weak self] surahs in
                self?.surahs = surahs
                if self?.recentSurah == nil {
                    self?.recentSurah = surahs.first
                }
            }
            .store(in: &cancellables)
    }
    
    public func fetchSettingsResources() {
        guard !isLoadingResources else { return }
        isLoadingResources = true
        
        let lang = selectedLanguageCode
        let language = lang == "en" ? "english" : lang
        
        resourceRepository.getLanguages()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.isLoadingResources = false } receiveValue: { [weak self] in self?.availableLanguages = $0 }
            .store(in: &cancellables)
            
        resourceRepository.getTranslationsList(language: language)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] in self?.availableTranslations = $0 }
            .store(in: &cancellables)
            
        resourceRepository.getTafsirsList(language: language)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] in self?.availableTafsirs = $0 }
            .store(in: &cancellables)
            
        resourceRepository.getRecitationsList(language: language)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] in self?.availableReciters = $0 }
            .store(in: &cancellables)
    }
}
