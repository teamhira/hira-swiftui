//
//  QuranViewModel+Audio.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI
import Combine

extension QuranViewModel {
    public func playCurrentSurah(surah: Surah) {
        guard let cachedAyahs = ayahCache[surah.number], !cachedAyahs.isEmpty else {
            fetchAyahs(for: surah, language: selectedLanguageCode)
            return
        }

        if showWordAudio {
            let startAyah = activeAyah ?? cachedAyahs.first
            if let ayah = startAyah {
                self.activeAyah = ayah
                recitationManager.playWords(ayah.words)
            }
        } else {
            let verseKey = activeAyah.map { "\($0.surahNumber):\($0.number)" }
            recitationManager.playChapter(
                surahNumber: surah.number, 
                recitationId: selectedReciterId, 
                atVerseKey: verseKey
            )
        }
    }
    
    public func toggleAutoScroll(for surah: Surah) {
        autoScroll.toggle()
        if autoScroll {
            if recitationManager.status != .playing {
                startTeleprompter(for: surah)
            }
        } else {
            stopTeleprompter()
        }
    }
    
    public func startTeleprompter(for surah: Surah) {
        if ayahCache[surah.number] == nil {
            fetchAyahs(for: surah, language: selectedLanguageCode)
        }
        
        audioRepository.getAudioByChapter(recitationId: selectedReciterId, chapterNumber: surah.number, segments: true)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] (response: AudioFileResponse) in
                self?.autoScrollTimestamps = response.timestamps ?? []
                self?.waitForAyahsAndStart(surah: surah)
            }
            .store(in: &cancellables)
    }
    
    func waitForAyahsAndStart(surah: Surah) {
        if let ayahs = ayahCache[surah.number], !ayahs.isEmpty, isLoadingAyahs[surah.number] != true {
            activeAyah = ayahs.first
            initiateCountdown(for: surah)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.waitForAyahsAndStart(surah: surah)
            }
        }
    }
    
    func initiateCountdown(for surah: Surah) {
        if activeAyah == nil {
            activeAyah = ayahCache[surah.number]?.first
        }
        guard let current = activeAyah else { return }
        let verseKey = "\(current.surahNumber):\(current.number)"
        
        if let timestamp = autoScrollTimestamps.first(where: { $0.verseKey == verseKey }) {
            activeAyahDurationMs = timestamp.timestampTo - timestamp.timestampFrom
        } else {
            activeAyahDurationMs = 5000 
        }
        
        activeAyahElapsedMs = 0
        
        autoScrollTimer?.invalidate()
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.tickTeleprompter()
        }
    }
    
    func tickTeleprompter() {
        activeAyahElapsedMs += 500
        if activeAyahElapsedMs >= activeAyahDurationMs {
            autoScrollTimer?.invalidate()
            moveToNextAyahOptional(isTeleprompter: true)
        }
    }
    
    func stopTeleprompter() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    func handlePlaybackFinished() {
        guard !recitationManager.isPlayingChapter else { return }
        moveToNextAyahOptional(isTeleprompter: false)
    }
    
    func syncActiveAyah(with verseKey: String?) {
        guard let key = verseKey else { return }
        let parts = key.split(separator: ":")
        guard parts.count == 2, let surahId = Int(parts[0]) else { return }
        
        if let ayahs = ayahCache[surahId], let matchingAyah = ayahs.first(where: { "\($0.surahNumber):\($0.number)" == key }) {
            self.activeAyah = matchingAyah
        }
    }

    func moveToNextAyahOptional(isTeleprompter: Bool = false) {
        guard let current = activeAyah else { return }
        guard let surah = surahs.first(where: { $0.number == current.surahNumber }) else { return }
        
        let surahAyahs = ayahCache[surah.number] ?? []
        
        if let index = surahAyahs.firstIndex(where: { $0.id == current.id }) {
            if index < surahAyahs.count - 1 {
                let next = surahAyahs[index + 1]
                activeAyah = next
                if isTeleprompter {
                    initiateCountdown(for: surah)
                } else if showWordAudio {
                    playCurrentSurah(surah: surah)
                }
            } else if isTeleprompter {
                if let surahIndex = surahs.firstIndex(where: { $0.number == surah.number }),
                   surahIndex < surahs.count - 1 {
                    autoScrollNextSurah = surahs[surahIndex + 1]
                    showingAutoScrollNextSurahAlert = true
                } else {
                    autoScroll = false
                }
            }
        }
    }
}
