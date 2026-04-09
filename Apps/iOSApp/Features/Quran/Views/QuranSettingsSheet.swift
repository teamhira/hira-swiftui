//
//  QuranSettingsSheet.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct QuranSettingsSheet: View {
    @Bindable var viewModel: QuranViewModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    
    private let tabs = [
        ("Display", "macwindow"),
        ("Typography", "textformat"),
        ("Audio", "speaker.wave.2")
    ]
    
    public var body: some View {
        let colors = appEnv.theme.current
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // MARK: - Premium Tab Picker
                    HStack(spacing: 8) {
                        ForEach(0..<tabs.count, id: \.self) { index in
                            Button(action: { 
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { 
                                    selectedTab = index 
                                } 
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: tabs[index].1)
                                        .font(.system(size: 14, weight: .semibold))
                                    
                                    if selectedTab == index {
                                        Text(tabs[index].0)
                                            .font(.system(size: 13, weight: .bold))
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    ZStack {
                                        if selectedTab == index {
                                            Capsule()
                                                .fill(colors.primary.opacity(0.1))
                                                .matchedGeometryEffect(id: "tab", in: tabNamespace)
                                        }
                                    }
                                )
                                .foregroundColor(selectedTab == index ? colors.primary : colors.foreground.opacity(0.4))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(colors.background)
                    
                    Divider().opacity(0.05)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            if selectedTab == 0 {
                                displaySettings
                            } else if selectedTab == 1 {
                                typographySettings
                            } else {
                                audioSettings
                            }
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle("Quran Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(colors.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Text("Save")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(colors.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(colors.primary.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
    
    @Namespace private var tabNamespace
    
    // MARK: - Sections
    
    @ViewBuilder
    private var displaySettings: some View {
        let colors = appEnv.theme.current
        VStack(spacing: 20) {
            ProfileSectionView(title: "Visual Theme") {
                VStack(spacing: 0) {
                    themeOption(name: "System", icon: "iphone", tag: "System")
                    themeOption(name: "Light", icon: "sun.max.fill", tag: "Light")
                    themeOption(name: "Dark", icon: "moon.stars.fill", tag: "Dark")
                    themeOption(name: "Sepia", icon: "book.fill", tag: "Sepia")
                }
            }
            
            ProfileSectionView(title: "Layout Mode") {
                Picker("Layout", selection: $viewModel.readingMode) {
                    ForEach(QuranReadingMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue.capitalized).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 8)
            }
            
            ProfileMenuRow(icon: "battery.100.bolt", title: "Prevent Sleep") {
                Toggle("", isOn: $viewModel.keepScreenOn)
                    .tint(colors.primary)
                    .labelsHidden()
            }
        }
    }
    
    @ViewBuilder
    private var typographySettings: some View {
        let colors = appEnv.theme.current
        VStack(spacing: 20) {
            ProfileSectionView(title: "Text Size") {
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "textformat.size.smaller")
                        Slider(value: $viewModel.textSize, in: 12...40, step: 1)
                            .tint(colors.primary)
                        Image(systemName: "textformat.size.larger")
                    }
                    .foregroundColor(colors.foreground.opacity(0.4))
                    
                    Text("Sample Arabic Text - \(Int(viewModel.textSize))pt")
                        .font(.custom("KFGQPC Uthman Taha Naskh", size: viewModel.textSize))
                        .foregroundColor(colors.primary)
                }
                .padding()
                .hiraCleanCard(colors: colors, radius: 20)
            }
            
            ProfileSectionView(title: "Content Visibility") {
                VStack(spacing: 12) {
                    ProfileMenuRow(icon: "character.bubble", title: "Translation") {
                        Toggle("", isOn: $viewModel.showTranslation)
                            .tint(colors.primary)
                            .labelsHidden()
                    }
                    ProfileMenuRow(icon: "abc", title: "Transliteration") {
                        Toggle("", isOn: $viewModel.showTransliteration)
                            .tint(colors.primary)
                            .labelsHidden()
                    }
                    ProfileMenuRow(icon: "paintpalette.fill", title: "Tajweed Colors") {
                        Toggle("", isOn: $viewModel.showTajweed)
                            .tint(colors.primary)
                            .labelsHidden()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var audioSettings: some View {
        let colors = appEnv.theme.current
        VStack(spacing: 20) {
            ProfileSectionView(title: "Playback Engine") {
                VStack(spacing: 12) {
                    ProfileMenuRow(icon: "waveform", title: "Enable Audio") {
                        Toggle("", isOn: $viewModel.audioEnabled)
                            .tint(colors.primary)
                            .labelsHidden()
                    }
                    ProfileMenuRow(icon: "arrow.up.and.down.and.sparkles", title: "Auto-Scroll") {
                        Toggle("", isOn: $viewModel.autoScroll)
                            .tint(colors.primary)
                            .labelsHidden()
                    }
                }
            }
            
            ProfileSectionView(title: "Audio Preferences") {
                ProfileMenuRow(icon: "person.wave.2.fill", title: "Reciter", value: viewModel.selectedReciter) {
                    // Logic for selection
                }
            }
        }
    }
    
    // MARK: - Components
    
    @ViewBuilder
    private func themeOption(name: String, icon: String, tag: String) -> some View {
        let colors = appEnv.theme.current
        ProfileMenuRow(icon: icon, title: name) {
            if viewModel.theme == tag {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(colors.primary)
            }
        }
        .onTapGesture {
            withAnimation {
                viewModel.theme = tag
            }
        }
    }
}
