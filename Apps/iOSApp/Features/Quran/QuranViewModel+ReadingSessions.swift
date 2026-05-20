//
//  QuranViewModel+ReadingSessions.swift
//  Hira
//
//  Created by Ryuk on 17/04/26.
//

import SwiftUI
import Combine

extension QuranViewModel {

    /// Fetches user reading sessions history.
    public func fetchReadingSessions() {
        guard !isFetchingReadingSessions else { return }
        isFetchingReadingSessions = true

        getReadingSessionsUseCase.execute(first: 10, after: nil, last: nil, before: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isFetchingReadingSessions = false
            } receiveValue: { [weak self] (entities, _) in
                self?.readingSessions = entities
            }
            .store(in: &cancellables)
    }

    /// Starts a new tracking session when entering SurahDetailView.
    /// Also starts activity day tracking immediately (no countdown).
    public func startReadingSessionTracking() {
        stopReadingSessionTracking()

        guard !isRedirectedFromBookmark else {
            print("📖 Reading Sessions: Redirected from bookmark, tracking disabled.")
            return
        }

        hasFulfilledFirstMinute = false
        lastRecordedAyah = nil

        print("📖 Reading Sessions: Starting 15s countdown...")
        readingSessionFirstPostTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: false) { [weak self] _ in
            print("📖 Reading Sessions: 15s fulfilled. Recording first point.")
            self?.hasFulfilledFirstMinute = true
            self?.triggerReadingSessionPost()
        }

        // Activity Days starts immediately — no countdown
        startActivityDayTracking()
    }

    /// Stops all tracking and cleans up timers.
    public func stopReadingSessionTracking() {
        readingSessionFirstPostTimer?.invalidate()
        readingSessionFirstPostTimer = nil
        readingSessionDebounceTimer?.invalidate()
        readingSessionDebounceTimer = nil
        isRedirectedFromBookmark = false

        // Also stops and flushes activity day tracking
        stopActivityDayTracking()
    }

    /// Records the current position for both Reading Sessions and Activity Days.
    public func updateReadingSession(ayah: QuranAyah) {
        guard !isRedirectedFromBookmark else { return }

        // Activity Days: update on every ayah change (accumulates ranges, no countdown)
        updateActivityDay(ayah: ayah)

        // Reading Sessions: only post after the initial 15-second threshold
        guard hasFulfilledFirstMinute else { return }

        readingSessionDebounceTimer?.invalidate()
        readingSessionDebounceTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            self?.triggerReadingSessionPost()
        }
    }

    private func triggerReadingSessionPost() {
        guard let currentAyah = activeAyah else { return }

        if let last = lastRecordedAyah,
           last.surah == currentAyah.surahNumber,
           last.ayah == currentAyah.number { return }

        print("📖 Reading Sessions: Posting -> Surah \(currentAyah.surahNumber) Ayah \(currentAyah.number)")

        addReadingSessionUseCase.execute(chapterNumber: currentAyah.surahNumber, verseNumber: currentAyah.number)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] message in
                print("📖 Reading Sessions API: \(message)")
                self?.lastRecordedAyah = (currentAyah.surahNumber, currentAyah.number)
            }
            .store(in: &cancellables)
    }
}
