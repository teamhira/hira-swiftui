//
//  TarteelViewModel.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI
import Observation

public struct TarteelWordResult: Hashable {
    public let word: String
    public let isCorrect: Bool
    public let mistake: String?
}

public struct TarteelResult: Identifiable, Hashable {
    public let id = UUID()
    public let ayahNumber: Int
    public let isCorrect: Bool
    public let feedback: String
    public let correction: String
    public var wordResults: [TarteelWordResult] = []
}

public struct TarteelHistoryItem: Identifiable, Hashable {
    public let id = UUID()
    public let surahNumber: Int
    public let surahName: String
    public let surahNameArabic: String
    public let score: Double
    public let date: Date
}

@Observable
public final class TarteelViewModel {
    public var currentSurah: Surah?
    public var isRecording: Bool = false
    public var results: [String: TarteelResult] = [:] // Ayah ID -> Result
    public var surahProgress: Double = 0.0
    
    public var surahs: [Surah] = [
        Surah(id: "1", number: 1, name: "Al-Fatihah", nameArabic: "الفاتحة", nameTranslation: "The Opening", versesCount: 7, revelationPlace: "Makkah"),
        Surah(id: "2", number: 2, name: "Al-Baqarah", nameArabic: "البقرة", nameTranslation: "The Cow", versesCount: 286, revelationPlace: "Madinah"),
        Surah(id: "3", number: 3, name: "Ali 'Imran", nameArabic: "آل عمران", nameTranslation: "Family of Imran", versesCount: 200, revelationPlace: "Madinah"),
        Surah(id: "114", number: 114, name: "An-Nas", nameArabic: "الناس", nameTranslation: "Mankind", versesCount: 6, revelationPlace: "Makkah")
    ]
    
    public var history: [TarteelHistoryItem] = [
        TarteelHistoryItem(surahNumber: 1, surahName: "Al-Fatihah", surahNameArabic: "الفاتحة", score: 0.95, date: Date()),
        TarteelHistoryItem(surahNumber: 114, surahName: "An-Nas", surahNameArabic: "الناس", score: 0.88, date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())
    ]
    
    public init() {}
    
    public func startRecording() {
        isRecording = true
    }
    
    public func stopRecording(for ayah: QuranAyah) {
        isRecording = false
        // Simulate AI Correction
        let isCorrect = Bool.random()
        let words = ayah.textArabic.components(separatedBy: .whitespaces)
        var wordResults: [TarteelWordResult] = []
        
        for word in words {
            wordResults.append(TarteelWordResult(
                word: word, 
                isCorrect: isCorrect ? true : Bool.random(),
                mistake: isCorrect ? nil : "Pronunciation error"
            ))
        }
        
        let result = TarteelResult(
            ayahNumber: ayah.number,
            isCorrect: isCorrect,
            feedback: isCorrect ? "Perfect pronunciation!" : "Articulation error in 'Makhraj'.",
            correction: isCorrect ? "" : "Ensure the tongue touches the upper gums for this letter.",
            wordResults: wordResults
        )
        results[ayah.id] = result
        updateProgress()
    }
    
    private func updateProgress() {
        let correctCount = results.values.filter { $0.isCorrect }.count
        surahProgress = Double(correctCount) / Double(max(results.count, 1))
    }
    
    public func saveToHistory() {
        guard let surah = currentSurah else { return }
        let newItem = TarteelHistoryItem(
            surahNumber: surah.number,
            surahName: surah.name,
            surahNameArabic: surah.nameArabic,
            score: surahProgress,
            date: Date()
        )
        // In a real app, this would be saved to a database
        print("Saving to history: \(newItem.surahName) - \(Int(newItem.score * 100))%")
    }
    
    public func ayahs(for surah: Surah) -> [QuranAyah] {
        let count = min(surah.versesCount, 10)
        return (1...count).map { i in
            QuranAyah(
                surahNumber: surah.number,
                number: i,
                textArabic: getMockArabic(for: surah.number, ayah: i),
                textLatin: "Latin text for ayah \(i)",
                translation: "Translation for ayah \(i)"
            )
        }
    }
    
    private func getMockArabic(for surah: Int, ayah: Int) -> String {
        if surah == 1 {
            let fatihah = [
                "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                "ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ",
                "ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                "مَٰلِكِ يَوْمِ ٱلدِّينِ",
                "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ",
                "ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ",
                "صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ"
            ]
            return fatihah[safe: ayah - 1] ?? "بِسْمِ ٱللَّهِ"
        }
        return "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
