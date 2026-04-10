//
//  ArticleModel.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI

public struct Article: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let date: String
    public let description: String
    public let content: String
    public let image: String
    public let category: String
    public let readTime: String
    public let author: String
}

extension Article {
    public static var mocks: [Article] = [
        Article(
            title: "The Power of Night Prayer (Tahajjud)",
            date: "Apr 03, 2026",
            description: "Explore the internal spiritual benefits of the last third of the night.",
            content: "Tahajjud is a voluntary prayer which is offered by the followers of Islam. It is not one of the five obligatory prayers required of all Muslims, although the Islamic prophet, Muhammad was recorded as performing the tahajjud prayer regularly himself and encouraging his companions as well. \n\nPerforming Tahajjud regularly brings one closer to Allah, increases spiritual purity, and provides strength for daily challenges.",
            image: "mosque_dawn",
            category: "Spiritual",
            readTime: "5 min read",
            author: "Hira Editorial"
        ),
        Article(
            title: "Understanding Quranic Wisdom",
            date: "Apr 01, 2026",
            description: "A deeper look into how to apply Quranic teachings in modern life.",
            content: "The Quran is not just a book of signs, but a book of guidance. Every verse contains wisdom that, when understood and applied, can transform lives. This article explores practical ways to engage with the Quran's wisdom in the 21st century.",
            image: "quran_open",
            category: "Education",
            readTime: "8 min read",
            author: "Dr. Ahmed Ibrahim"
        ),
        Article(
            title: "Ramadan 2026: Preparation Guide",
            date: "Mar 25, 2026",
            description: "Get ready for the holy month with physical and spiritual preparations.",
            content: "Preparation for Ramadan starts in Rajab and Sha'ban. This guide covers nutritional advice, goal-setting, and spiritual exercises to help you make the most of the upcoming holy month.",
            image: "ramadan_prep",
            category: "Guide",
            readTime: "12 min read",
            author: "Fatima Az-Zahra"
        )
    ]
}
