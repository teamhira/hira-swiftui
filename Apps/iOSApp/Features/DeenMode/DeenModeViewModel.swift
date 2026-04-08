//
//  DeenModeViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation
import Observation

@Observable
public final class DeenModeViewModel {
    public var isDeenModeActive: Bool = false
    public var settings: [DeenSetting] = [
        DeenSetting(title: "Mute Notifikasi", isActive: true),
        DeenSetting(title: "Mode Fokus Quran", isActive: true),
        DeenSetting(title: "Otomatisasi Jadwal Sholat", isActive: false)
    ]
    
    public init() {}
    
    public func toggleSetting(at index: Int) {
        settings[index].isActive.toggle()
    }
}

public struct DeenSetting: Identifiable {
    public let id = UUID()
    let title: String
    var isActive: Bool
}
