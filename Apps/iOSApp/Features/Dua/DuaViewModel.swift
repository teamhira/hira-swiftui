//
//  DuaViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI
import Observation

// MARK: - Models
public struct DuaItem: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let description: String
    public let category: String
    public let arabic: String
    public let translation: String
    public let reference: String?
}

// MARK: - ViewModel
@Observable
class DuaViewModel {
    
    // MARK: - State
    var searchQuery: String = ""
    var selectedCategory: String = "dua_category_all"
    
    // MARK: - Data Source
    // Sample Duas
    private let sampleDuas: [DuaItem] = [
        DuaItem(
            title: "Protection from Harm",
            description: "Dua recited every morning and evening for safety.",
            category: "dua_category_daily",
            arabic: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
            translation: "In the Name of Allah, who with His Name nothing can cause harm in the earth nor in the heavens, and He is the All-Hearing, the All-Knowing.",
            reference: "Sunan Abu Dawud"
        ),
        DuaItem(
            title: "Entering the Home",
            description: "To seek blessings when returning home.",
            category: "dua_category_daily",
            arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ الْمَوْلَجِ وَخَيْرَ الْمَخْرَجِ",
            translation: "O Allah, I ask You for the best entrance and the best exit.",
            reference: "Sunan Abu Dawud"
        ),
        DuaItem(
            title: "Faith and Guidance",
            description: "A Quranic prayer for firm faith.",
            category: "dua_category_quranic",
            arabic: "رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً",
            translation: "Our Lord, let not our hearts deviate after You have guided us and grant us from Yourself mercy.",
            reference: "Surah Ali 'Imran: 8"
        ),
        DuaItem(
            title: "Knowledge",
            description: "To seek increase in beneficial knowledge.",
            category: "dua_category_quranic",
            arabic: "رَّبِّ زِدْنِي عِلْمًا",
            translation: "My Lord, increase me in knowledge.",
            reference: "Surah Ta-Ha: 114"
        ),
        DuaItem(
            title: "Patience and Strength",
            description: "Prophetic prayer for steadfastness.",
            category: "dua_category_prophetic",
            arabic: "يَا مُقَلِّبَ الْقُلُوبِ ثَبِّتْ قَلْبِي عَلَى دِينِكَ",
            translation: "O Changer of hearts, make my heart firm upon Your religion.",
            reference: "Jami' at-Tirmidhi"
        )
    ]
    
    // MARK: - Computed Properties
    var categories: [(id: String, icon: String)] = [
        ("dua_category_all", "square.grid.2x2.fill"),
        ("dua_category_daily", "sun.max.fill"),
        ("dua_category_quranic", "book.fill"),
        ("dua_category_prophetic", "person.fill")
    ]
    
    var filteredDuas: [DuaItem] {
        var results = sampleDuas
        
        // Filter by category
        if selectedCategory != "dua_category_all" {
            results = results.filter { $0.category == selectedCategory }
        }
        
        // Filter by search query
        if !searchQuery.isEmpty {
            results = results.filter { 
                $0.title.localizedCaseInsensitiveContains(searchQuery) || 
                $0.description.localizedCaseInsensitiveContains(searchQuery) ||
                $0.translation.localizedCaseInsensitiveContains(searchQuery)
            }
        }
        
        return results
    }
    
    func countForCategory(_ categoryId: String) -> Int {
        if categoryId == "dua_category_all" {
            return sampleDuas.count
        }
        return sampleDuas.filter { $0.category == categoryId }.count
    }
}
