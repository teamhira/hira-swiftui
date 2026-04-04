//
//  QuranTopTabs.swift
//  Hira
//

import SwiftUI

public struct QuranTopTabs: View {
    @Binding var selectedTab: QuranTopTab
    @Environment(\.appEnvironment) private var appEnv
    
    public var body: some View {
        Picker(appEnv.language.localizedString("quran_title"), selection: $selectedTab) {
            ForEach(QuranTopTab.allCases, id: \.self) { tab in
                Text(tab.title(language: appEnv.language)).tag(tab)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
}

public struct QuranBottomTabs: View {
    @Binding var selectedTab: QuranBottomTab
    @Environment(\.appEnvironment) private var appEnv
    
    public var body: some View {
        Picker("", selection: $selectedTab) {
            ForEach(QuranBottomTab.allCases, id: \.self) { tab in
                Text(tab.title(language: appEnv.language)).tag(tab)
            }
        }
        .pickerStyle(.segmented)
        .frame(maxWidth: 240) // Keep it small and centered
        .padding(.bottom, 30) // Positioned above the main bottom tabs
    }
}
