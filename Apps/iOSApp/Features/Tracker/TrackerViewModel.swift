//
//  TrackerViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation
import Observation

@Observable
public final class TrackerViewModel {
    public var stats: [TrackerStat] = [
        TrackerStat(title: "Sholat", value: "95%", icon: "hands.sparkles.fill"),
        TrackerStat(title: "Dzikir", value: "720", icon: "circle.grid.3x3.circle.fill"),
        TrackerStat(title: "Sedekah", value: "3x", icon: "banknote.fill")
    ]
    
    public init() {}
}

public struct TrackerStat: Identifiable {
    public let id = UUID()
    let title: String
    let value: String
    let icon: String
}
