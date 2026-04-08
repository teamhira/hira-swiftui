//
//  HomeFeatureStoreModel.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI
import Observation

@Observable
public final class HomeFeatureStoreModel {
    private static let storageKey = "home_features_v1"
    
    public var features: [HomeFeatureModel] = [] {
        didSet {
            save()
        }
    }
    
    public var visibleFeatures: [HomeFeatureModel] {
        features.filter { $0.isVisible }
    }
    
    public init() {
        if let data = UserDefaults.standard.data(forKey: Self.storageKey),
           let decoded = try? JSONDecoder().decode([HomeFeatureModel].self, from: data) {
            self.features = decoded
        } else {
            // Default list if not initialized
            let defaultTypes: [HomeFeatureType] = [
                .zakat, .sadaqah, .qibla, .tasbih, .dua, 
                .hadith, .achievements, .mosques, .khatam, .deenMode,
                .journal, .askAI, .tracker, .calendar, .halal,
                .hajjJourney, .hajjUmrah
            ]
            
            // Set first 5 as visible by default for the home grid
            self.features = defaultTypes.enumerated().map { (index, type) in
                HomeFeatureModel(type: type, isVisible: index < 5)
            }
        }
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(features) {
            UserDefaults.standard.set(encoded, forKey: Self.storageKey)
        }
    }
    
    public func toggleVisibility(for type: HomeFeatureType) {
        if let index = features.firstIndex(where: { $0.type == type }) {
            features[index].isVisible.toggle()
        }
    }
    
    public func move(from source: IndexSet, to destination: Int) {
        features.move(fromOffsets: source, toOffset: destination)
    }
}
