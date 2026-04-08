//
//  HadithViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI
import Observation

// MARK: - Models
public struct HadithItem: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let body: String
    public let source: String
    public let narrator: String
    public let category: String // Collection ID
    public let arabic: String?
    
    public init(title: String, body: String, source: String, narrator: String, category: String, arabic: String? = nil) {
        self.title = title
        self.body = body
        self.source = source
        self.narrator = narrator
        self.category = category
        self.arabic = arabic
    }
}

public struct HadithCollection: Identifiable, Hashable {
    public let id: String // Key for localization
    public let icon: String
    public let count: Int
    
    public init(id: String, icon: String, count: Int) {
        self.id = id
        self.icon = icon
        self.count = count
    }
}

// MARK: - ViewModel
@Observable
public final class HadithViewModel {
    
    // MARK: - State
    public var searchQuery: String = ""
    public var selectedCollection: String = "hadith_col_all"
    
    // MARK: - Data Source
    public let featuredHadith = HadithItem(
        title: "hadith_featured_title",
        body: "hadith_featured_body",
        source: "Sahih Bukhari",
        narrator: "Umar bin Al-Khattab",
        category: "hadith_col_bukhari"
    )
    
    public let collections: [HadithCollection] = [
        HadithCollection(id: "hadith_col_arbain", icon: "book.closed.fill", count: 42),
        HadithCollection(id: "hadith_col_bukhari", icon: "books.vertical.fill", count: 7563),
        HadithCollection(id: "hadith_col_muslim", icon: "book.fill", count: 3033),
        HadithCollection(id: "hadith_col_riyadh", icon: "leaf.fill", count: 1896)
    ]
    
    public let sampleHadiths: [HadithItem] = [
        HadithItem(
            title: "Niat (Intention)",
            body: "Innamal a'malu binniyat... Actions are but by intentions and every man shall have only that which he intended.",
            source: "Sahih Bukhari",
            narrator: "Umar bin Al-Khattab",
            category: "hadith_col_arbain",
            arabic: "إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى"
        ),
        HadithItem(
            title: "Pillars of Islam",
            body: "Islam is built upon five pillars...",
            source: "Sahih Muslim",
            narrator: "Abdullah bin Umar",
            category: "hadith_col_arbain",
            arabic: "بُنِيَ الْإِسْلَامُ عَلَى خَمْسٍ"
        )
    ]
    
    public init() {}
    
    // MARK: - Logic
    public func filteredHadiths(for collectionId: String) -> [HadithItem] {
        if collectionId == "hadith_col_all" {
            return sampleHadiths
        }
        return sampleHadiths.filter { $0.category == collectionId }
    }
    
    public func searchHadiths() -> [HadithItem] {
        if searchQuery.isEmpty { return [] }
        return sampleHadiths.filter {
            $0.title.localizedCaseInsensitiveContains(searchQuery) ||
            $0.body.localizedCaseInsensitiveContains(searchQuery) ||
            $0.narrator.localizedCaseInsensitiveContains(searchQuery)
        }
    }
}
