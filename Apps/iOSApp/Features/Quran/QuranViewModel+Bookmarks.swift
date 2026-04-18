//
//  QuranViewModel+Bookmarks.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI
import Combine

extension QuranViewModel {
    public func fetchBookmarks() {
        fetchBookmarks(isNextPage: false)
    }
    
    public func loadMoreBookmarks() {
        guard let pagination = bookmarksPagination, pagination.hasNextPage, !isFetchingBookmarks else { return }
        fetchBookmarks(isNextPage: true)
    }
    
    private func fetchBookmarks(isNextPage: Bool) {
        guard !isFetchingBookmarks else { return }
        isFetchingBookmarks = true
        
        let after = isNextPage ? bookmarksPagination?.endCursor : nil
        
        getBookmarksUseCase.execute(mushaf: 1, first: 15, after: after)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isFetchingBookmarks = false
            } receiveValue: { [weak self] (entities, pagination) in
                guard let self = self else { return }
                self.bookmarksPagination = pagination
                
                if !isNextPage {
                    self.bookmarks = []
                    self.readingBookmark = entities.first(where: { $0.isReading })
                }
                
                let newBookmarks = entities
                    .filter { !$0.isReading }
                    .map { entity in
                        let surah = self.surahs.first(where: { $0.number == entity.key })
                        return QuranBookmark(
                            surahNumber: entity.key,
                            surahName: surah?.name,
                            surahNameArabic: surah?.nameArabic,
                            ayahNumber: entity.verseNumber ?? 0,
                            timeAgo: self.formatDate(entity.createdAt),
                            arabicText: nil,
                            apiId: entity.id
                        )
                    }
                
                if isNextPage {
                    self.bookmarks.append(contentsOf: newBookmarks)
                } else {
                    self.bookmarks = newBookmarks
                }
            }
            .store(in: &cancellables)
    }
    
    public func deleteBookmark(id: String) {
        deleteBookmarkUseCase.execute(id: id)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] _ in
                self?.showToast("Bookmark deleted")
                self?.fetchBookmarks()
            }
            .store(in: &cancellables)
    }
    
    public func fetchSurahBookmarks(surah: Surah) {
        getBookmarksAyahsRangeUseCase.execute(chapterNumber: surah.number, fromAyah: 1, toAyah: surah.versesCount, mushaf: 1)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.syncOptimisticBookmarksFromLocal()
                }
            } receiveValue: { [weak self] (entities, _) in
                guard let self = self else { return }
                for entity in entities {
                    if !entity.isReading, let verseNumber = entity.verseNumber {
                        let key = "\(entity.key):\(verseNumber)"
                        self.optimisticBookmarks.insert(key)
                        self.bookmarkedAyahIds[key] = entity.id
                    }
                }
            }
            .store(in: &cancellables)
    }

    public func syncOptimisticBookmarksFromLocal() {
        for bookmark in bookmarks {
            let key = "\(bookmark.surahNumber):\(bookmark.ayahNumber)"
            optimisticBookmarks.insert(key)
            if let apiId = bookmark.apiId {
                bookmarkedAyahIds[key] = apiId
            }
        }
    }

    public func markAsLastRead(ayah: QuranAyah) {
        addBookmarkUseCase.execute(type: "ayah", key: ayah.surahNumber, verseNumber: ayah.number, isReading: true, mushaf: 1)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] _ in self?.fetchBookmarks() }
            .store(in: &cancellables)
    }
    
    public func isBookmarked(surah: Int, ayah: Int) -> Bool {
        return optimisticBookmarks.contains("\(surah):\(ayah)")
    }

    public func toggleBookmark(ayah: QuranAyah) {
        let key = "\(ayah.surahNumber):\(ayah.number)"
        let wasBookmarked = optimisticBookmarks.contains(key)
        let isNowBookmarked = !wasBookmarked
        
        if isNowBookmarked {
            optimisticBookmarks.insert(key)
            showToast("Added to bookmarks")
        } else {
            optimisticBookmarks.remove(key)
            showToast("Removed from bookmarks")
        }
        
        bookmarkTimers[key]?.invalidate()
        bookmarkTimers[key] = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] _ in
            self?.commitBookmarkState(ayah: ayah, isNowBookmarked: isNowBookmarked)
        }
    }
    
    private func commitBookmarkState(ayah: QuranAyah, isNowBookmarked: Bool) {
        let key = "\(ayah.surahNumber):\(ayah.number)"
        let hasApiId = bookmarkedAyahIds[key] != nil
        
        if isNowBookmarked && !hasApiId {
            addBookmarkUseCase.execute(
                type: "ayah",
                key: ayah.surahNumber,
                verseNumber: ayah.number,
                isReading: nil,
                mushaf: 1
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.optimisticBookmarks.remove(key)
                }
            } receiveValue: { [weak self] entity in
                if let newId = entity?.id {
                    self?.bookmarkedAyahIds[key] = newId
                }
                if let surah = self?.surahs.first(where: { $0.number == ayah.surahNumber }) {
                    self?.fetchSurahBookmarks(surah: surah)
                }
            }
            .store(in: &cancellables)
            
        } else if !isNowBookmarked && hasApiId {
            if let apiId = bookmarkedAyahIds[key] {
                deleteBookmarkUseCase.execute(id: apiId)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.optimisticBookmarks.insert(key)
                        }
                    } receiveValue: { [weak self] _ in
                        self?.bookmarkedAyahIds.removeValue(forKey: key)
                        if let surah = self?.surahs.first(where: { $0.number == ayah.surahNumber }) {
                            self?.fetchSurahBookmarks(surah: surah)
                        }
                    }
                    .store(in: &cancellables)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
