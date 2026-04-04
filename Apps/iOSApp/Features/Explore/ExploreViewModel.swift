//
//  ExploreViewModel.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI
import Observation

public struct ExploreReel: Identifiable {
    public let id = UUID()
    public let title: String
    public let subtitle: String
    public let duration: String
    public let imageName: String
}

public struct ExploreEvent: Identifiable {
    public let id = UUID()
    public let title: String
    public let date: String
    public let location: String
    public let imageName: String
}

public struct ExploreCategory: Identifiable {
    public let id = UUID()
    public let titleKey: String
    public let descKey: String
    public let icon: String
}

@Observable
public class ExploreViewModel {
    public var searchQuery = ""
    
    public let reels = [
        ExploreReel(title: "Morning Dhikr", subtitle: "Beautiful recitation of...", duration: "2:30", imageName: "mosque_1"),
        ExploreReel(title: "Quran Recitation", subtitle: "Surah Al-Fatiha with...", duration: "3:15", imageName: "mosque_2"),
        ExploreReel(title: "Prayer Guide", subtitle: "Step by step...", duration: "5:00", imageName: "mosque_1")
    ]
    
    public let events = [
        ExploreEvent(title: "Quran Recitation Competition", date: "15 Dec 2024", location: "Jakarta, Indonesia", imageName: "mosque_1"),
        ExploreEvent(title: "Islamic Knowledge Seminar", date: "22 Dec 2024", location: "Bandung, Indonesia", imageName: "mosque_2"),
        ExploreEvent(title: "Community Iftar Gathering", date: "28 Dec 2024", location: "Surabaya, Indonesia", imageName: "mosque_1")
    ]
    
    public let categories = [
        ExploreCategory(titleKey: "explore_category_hadith", descKey: "explore_category_hadith_desc", icon: "doc.text.fill"),
        ExploreCategory(titleKey: "explore_category_articles", descKey: "explore_category_articles_desc", icon: "newspaper.fill"),
        ExploreCategory(titleKey: "explore_category_qna", descKey: "explore_category_qna_desc", icon: "bubble.left.and.bubble.right.fill"),
        ExploreCategory(titleKey: "explore_category_halal", descKey: "explore_category_halal_desc", icon: "location.fill")
    ]
    
    public init() {}
}
