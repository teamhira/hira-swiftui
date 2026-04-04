//
//  PreviewData.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

extension User {
    public static let preview = User(
        id: "1",
        username: "ryuk",
        email: "ryuk@hira.com",
        role: "ADMIN"
    )
}

extension CoreData {
    public static let previewList = [
        CoreData(id: "1", title: "Introduction", description: "Learn how to use Hira"),
        CoreData(id: "2", title: "Daily Verse", description: "Read a new verse every day"),
        CoreData(id: "3", title: "Donation", description: "Support the project")
    ]
    
    public static let preview = previewList[0]
}

extension Surah {
    public static let preview = Surah(
        id: "1",
        number: 1,
        name: "Al-Fatihah",
        nameArabic: "الفاتحة",
        nameTranslation: "The Opening",
        versesCount: 7,
        revelationPlace: "Mecca"
    )
    
    public static let previewList = [
        preview,
        Surah(id: "2", number: 2, name: "Al-Baqarah", nameArabic: "البقرة", nameTranslation: "The Cow", versesCount: 286, revelationPlace: "Medina")
    ]
}

extension Ayah {
    public static let preview = Ayah(
        id: "1",
        surahId: "1",
        verseNumber: 1,
        verseKey: "1:1",
        text: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"
    )
}

extension Reciter {
    public static let preview = Reciter(
        id: "1",
        name: "Mishary Rashid Alafasy",
        style: "Murattal"
    )
}
