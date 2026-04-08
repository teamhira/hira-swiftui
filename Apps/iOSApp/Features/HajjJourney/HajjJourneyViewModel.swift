//
//  HajjJourneyViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation
import Observation

@Observable
public final class HajjJourneyViewModel {
    public var currentStep: String = "Tahap Persiapan Berkas"
    public var totalProgress: Double = 0.15
    public var checklist: [String] = ["Paspor & Visa", "Manasik Haji", "Cek Kesehatan", "Perlengkapan"]
    
    public init() {}
}
