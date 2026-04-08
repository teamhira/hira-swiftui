//
//  JournalViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation
import Observation

@Observable
public final class JournalViewModel {
    public var entries: [JournalEntry] = [
        JournalEntry(title: "Refleksi Surah Al-Kahf", preview: "Sangat tersentuh dengan kisah pemuda gua hari ini...", day: 4, monthAbb: "APR"),
        JournalEntry(title: "Syukur Hari Ini", preview: "Alhamdulillah dapat sholat berjamaah tepat waktu...", day: 5, monthAbb: "APR"),
        JournalEntry(title: "Belajar Sabar", preview: "Mempelajari kesabaran dari kisah Nabi Musa...", day: 6, monthAbb: "APR")
    ]
    
    public init() {}
}

public struct JournalEntry: Identifiable {
    public let id = UUID()
    let title: String
    let preview: String
    let day: Int
    let monthAbb: String
}
