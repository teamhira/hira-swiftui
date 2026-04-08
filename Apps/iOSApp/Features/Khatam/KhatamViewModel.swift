//
//  KhatamViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation
import Observation

@Observable
public final class KhatamViewModel {
    public var currentHalaman: Int = 390
    public var totalHalaman: Int = 604
    public var progress: Double { Double(currentHalaman) / Double(totalHalaman) }
    public var progressPercentage: Int { Int(progress * 100) }
    
    public var history: [KhatamRecord] = [
        KhatamRecord(surahName: "Al-Baqarah", range: "Halaman 10 - 20", date: "Kemarin"),
        KhatamRecord(surahName: "Ali 'Imran", range: "Halaman 20 - 30", date: "Hari Ini")
    ]
    
    public init() {}
}

public struct KhatamRecord: Identifiable {
    public let id = UUID()
    let surahName: String
    let range: String
    let date: String
}
