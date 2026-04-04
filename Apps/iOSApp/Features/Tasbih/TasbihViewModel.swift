//
//  TasbihViewModel.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI
import Observation

public struct Dhikr: Identifiable, Equatable {
    public let id = UUID()
    public let arabic: String
    public let transliteration: String
    public let translationKey: String
    public let isDaily: Bool
    
    public static let sampleDhikr: [Dhikr] = [
        Dhikr(arabic: "سُبْحَانَ ٱللَّٰهِ", transliteration: "Subhanallah", translationKey: "dhikr_subhanallah", isDaily: true),
        Dhikr(arabic: "ٱلْحَمْدُ لِلَّٰهِ", transliteration: "Alhamdulillah", translationKey: "dhikr_alhamdulillah", isDaily: true),
        Dhikr(arabic: "لَا إِلَٰهَ إِلَّا ٱللَّٰه", transliteration: "La ilaha illallah", translationKey: "dhikr_lailahaillallah", isDaily: true),
        Dhikr(arabic: "ٱللَّٰهُ أَكْبَرُ", transliteration: "Allahu Akbar", translationKey: "dhikr_allahuakbar", isDaily: true),
        Dhikr(arabic: "أَسْتَغْفِرُ ٱللَّٰهَ", transliteration: "Astaghfirullah", translationKey: "dhikr_astaghfirullah", isDaily: true),
        Dhikr(arabic: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ", transliteration: "Subhanallahi wa bihamdihi", translationKey: "dhikr_subhanallah_bihamdihi", isDaily: false),
        Dhikr(arabic: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِٱللَّٰهِ", transliteration: "La hawla wala quwwata illa billah", translationKey: "dhikr_lahawla", isDaily: false)
    ]
}

public struct DhikrSequenceItem: Identifiable, Equatable {
    public let id = UUID()
    public let dhikr: Dhikr
    public var loops: Int = 1
}

public struct TasbihBeadStyle: Identifiable, Equatable {
    public let id = UUID()
    public let name: String
    public let colors: [Color]
    public let isPremium: Bool
    
    public static let availableStyles: [TasbihBeadStyle] = [
        TasbihBeadStyle(name: "Classic Obsidian", colors: [Color.black, Color.gray.opacity(0.8)], isPremium: false),
        TasbihBeadStyle(name: "Pearl White", colors: [Color.white, Color.gray.opacity(0.3)], isPremium: false),
        TasbihBeadStyle(name: "Emerald Green", colors: [Color.green, Color.mint], isPremium: true),
        TasbihBeadStyle(name: "Amber Yellow", colors: [Color.yellow, Color.orange], isPremium: true),
        TasbihBeadStyle(name: "Sandalwood", colors: [Color(hex: "A67B5B"), Color(hex: "8B4513")], isPremium: true),
        TasbihBeadStyle(name: "Ebony", colors: [Color(hex: "3B2F2F"), Color.black], isPremium: true),
        TasbihBeadStyle(name: "Tiger Eye", colors: [Color.brown, Color.black], isPremium: true)
    ]
}

@Observable
public class TasbihViewModel {
    public var count: Int = 0
    public var target: Int = 33
    public var loop: Int = 1
    public var selectedStyle: TasbihBeadStyle = TasbihBeadStyle.availableStyles[0]
    
    // UI Settings
    public var isSoundEnabled: Bool = true
    public var isSessionCompleted: Bool = false
    public var isSwipedRightToIncrement: Bool = false // False = Left to +, True = Right to +
    
    // Multi-select sequence
    public var selectedDhikrIds: Set<UUID> = []
    public var dhikrSequence: [DhikrSequenceItem] = []
    public var currentSequenceIndex: Int = 0
    
    public var currentDhikr: Dhikr? {
        guard !dhikrSequence.isEmpty, currentSequenceIndex < dhikrSequence.count else {
            return nil
        }
        return dhikrSequence[currentSequenceIndex].dhikr
    }
    
    public init() {}
    
    /// Logic to handle cyclic/bouncing swipe directions
    public func handleSwipe(isLeft: Bool) {
        if count == 0 {
            // At zero, the direction for incrementing depends on which side you pull from
            if isLeft {
                isSwipedRightToIncrement = false // Pulling from right to left is now the +
                increment()
            } else {
                isSwipedRightToIncrement = true // Pulling from left to right is now the +
                increment()
            }
            return
        }
        
        // Standard progression based on current mode
        if isSwipedRightToIncrement {
            // Right is +, Left is -
            if !isLeft { increment() } else { decrement() }
        } else {
            // Left is +, Right is -
            if isLeft { increment() } else { decrement() }
        }
    }
    
    public func increment() {
        count += 1
        checkProgression()
    }
    
    public func decrement() {
        if count > 0 {
            count -= 1
        } else {
            // Optional: Toggle direction even on manual decrement to 0? 
            // User spec says when already at 0 and user swipe.
        }
    }
    
    public func cycleTarget() {
        if target == 33 {
            target = 99
        } else if target == 99 {
            target = 100
        } else {
            target = 33
        }
    }
    
    public func reset() {
        count = 0
        loop = 1
        currentSequenceIndex = 0
        isSessionCompleted = false
        isSwipedRightToIncrement = false
    }
    
    private func checkProgression() {
        if count >= target {
            if !dhikrSequence.isEmpty && currentSequenceIndex < dhikrSequence.count {
                let currentItem = dhikrSequence[currentSequenceIndex]
                if loop >= currentItem.loops {
                    if currentSequenceIndex < dhikrSequence.count - 1 {
                        currentSequenceIndex += 1
                        loop = 1
                        count = 0 
                    } else {
                        isSessionCompleted = true
                    }
                } else {
                    loop += 1
                    count = 0
                }
            } else {
                count = 0
                loop += 1
            }
        }
    }
    
    public func syncSequence() {
        let selectedItems = Dhikr.sampleDhikr.filter { selectedDhikrIds.contains($0.id) }
        dhikrSequence.removeAll { item in !selectedDhikrIds.contains(item.dhikr.id) }
        for dhikr in selectedItems {
            if !dhikrSequence.contains(where: { $0.dhikr.id == dhikr.id }) {
                dhikrSequence.append(DhikrSequenceItem(dhikr: dhikr))
            }
        }
        if currentSequenceIndex >= dhikrSequence.count { currentSequenceIndex = 0 }
    }
}
