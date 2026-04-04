//
//  CharityViewModel.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI
import Observation

@Observable
public class CharityViewModel {
    // Current state of the charity dashboard
    public var searchText: String = ""
    public var isSearching: Bool = false
    
    // Sample Data for "Suggested" or similar
    public let suggestionChips = [
        "Daily Du'as", "Qibla Finder", "Halal Scanner", "Topic Finder"
    ]
    
    public init() {}
    
    // Intent for navigation / search trigger
    public func triggerSearch() {
        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8)) {
            isSearching = true
        }
    }
}
