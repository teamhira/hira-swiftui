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
            var existingFeatures = decoded
            
            // Migration: Add missing features that might have been added in code updates
            let existingTypes = Set(existingFeatures.map { $0.type })
            let allTypes = HomeFeatureType.allCases
            
            for type in allTypes {
                if !existingTypes.contains(type) {
                    existingFeatures.append(HomeFeatureModel(type: type, isVisible: false))
                }
            }
            
            self.features = existingFeatures
        } else {
            // Default list if not initialized
            let defaultTypes = HomeFeatureType.allCases
            
            // Set first 8 as visible by default for the home grid
            self.features = defaultTypes.enumerated().map { (index, type) in
                HomeFeatureModel(type: type, isVisible: index < 8)
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
