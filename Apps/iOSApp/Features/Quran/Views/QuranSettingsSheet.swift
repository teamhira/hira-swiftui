//
//  QuranSettingsSheet.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct QuranSettingsSheet: View {
    @Environment(QuranViewModel.self) private var viewModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    
    @Namespace private var tabNamespace
    
    private let tabs = [
        ("Appearance", "sun.max.fill"),
        ("Content", "doc.text.fill"),
        ("Audio", "speaker.wave.3.fill")
    ]
    
    // MARK: - Resource Lists
    private var translations: [(id: Int, title: String, subtitle: String?, tagline: String?)] { 
        viewModel.availableTranslations.map { (id: $0.id, title: $0.name, subtitle: $0.authorName, tagline: $0.languageName) } 
    }
    private var tafsirs: [(id: Int, title: String, subtitle: String?, tagline: String?)] { 
        viewModel.availableTafsirs.map { (id: $0.id, title: $0.name, subtitle: $0.authorName, tagline: $0.languageName) } 
    }
    private var reciters: [(id: Int, title: String, subtitle: String?, tagline: String?)] { 
        viewModel.availableReciters.map { (id: $0.id, title: $0.reciterName, subtitle: $0.style, tagline: $0.translatedName.languageName.capitalized) } 
    }
    private var languages: [LanguageResponse] { viewModel.availableLanguages }

    public var body: some View {
        @Bindable var viewModel = viewModel
        let colors = appEnv.theme.current
        
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // MARK: - Premium Tab Bar
                    HStack(spacing: 0) {
                        ForEach(0..<tabs.count, id: \.self) { index in
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    selectedTab = index
                                }
                            }) {
                                VStack(spacing: 8) {
                                    Image(systemName: tabs[index].1)
                                        .font(.system(size: 18))
                                    Text(tabs[index].0)
                                        .font(.system(size: 11, weight: .bold))
                                }
                                .frame(maxWidth: .infinity)
                                .foregroundColor(selectedTab == index ? colors.primary : colors.foreground.opacity(0.3))
                                .overlay(alignment: .bottom) {
                                    if selectedTab == index {
                                        Capsule()
                                            .fill(colors.primary)
                                            .frame(width: 20, height: 3)
                                            .offset(y: 12)
                                            .matchedGeometryEffect(id: "underline", in: tabNamespace)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                    .background(colors.background)
                    
                    Divider().opacity(0.08)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 32) {
                            if selectedTab == 0 {
                                appearanceSection
                            } else if selectedTab == 1 {
                                contentSection
                            } else {
                                audioSection
                            }
                        }
                        .padding(24)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(colors.foreground.opacity(0.8))
                    }
                }
            }
            .onAppear {
                viewModel.fetchSettingsResources()
            }
            .fullScreenCover(isPresented: $showingTranslationSelector) {
                QuranResourceSelector(title: "Translation", items: translations, selection: $viewModel.selectedTranslationId)
            }
            .fullScreenCover(isPresented: $showingTafsirSelector) {
                QuranResourceSelector(title: "Tafsir Source", items: tafsirs, selection: $viewModel.selectedTafsirId)
            }
            .fullScreenCover(isPresented: $showingLanguageSelector) {
                QuranLanguageSelector(title: "Select Language", items: viewModel.availableLanguages, selection: $viewModel.selectedLanguageCode)
            }
            .fullScreenCover(isPresented: $showingReciterSelector) {
                QuranResourceSelector(title: "Select Reciter", items: reciters, selection: $viewModel.selectedReciterId)
            }
            .fullScreenCover(isPresented: $showingTajweedInfo) {
                QuranTajweedInfoSheet()
            }
        }
    }
    
    // MARK: - Appearance Section
    @ViewBuilder
    private var appearanceSection: some View {
        @Bindable var viewModel = viewModel
        let colors = appEnv.theme.current
        
        VStack(spacing: 24) {
            ProfileSectionView(title: "Interface Theme") {
                HStack(spacing: 12) {
                    themeBox(name: "Light", icon: "sun.max.fill", tag: "Light")
                    themeBox(name: "Dark", icon: "moon.stars.fill", tag: "Dark")
                    themeBox(name: "System", icon: "iphone", tag: "System")
                }
            }
            
            ProfileSectionView(title: "Text & Typography") {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Font Size")
                                .font(.system(size: 14, weight: .bold))
                            Spacer()
                            Text("\(Int(viewModel.textSize))pt")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(colors.primary)
                        }
                        
                        Slider(value: $viewModel.textSize, in: 20...48, step: 2)
                            .tint(colors.primary)
                    }
                    .padding(16)
                    .background(colors.foreground.opacity(0.03))
                    .cornerRadius(16)
                    
                    ProfileMenuRow(icon: "text.justify", title: "Reading Mode") {
                        Picker("", selection: $viewModel.readingMode) {
                            Text("List").tag(QuranReadingMode.list)
                            Text("Mushaf").tag(QuranReadingMode.page)
                        }
                        .pickerStyle(.menu)
                        .tint(colors.primary)
                    }
                }
            }
            
            ProfileSectionView(title: "Language") {
                resourceRow(
                    title: "App Language",
                    icon: "character.bubble.fill",
                    currentValue: viewModel.selectedLanguage
                ) {
                    showingLanguageSelector = true
                }
            }
        }
    }
    
    @State private var showingTranslationSelector = false
    @State private var showingTafsirSelector = false
    @State private var showingLanguageSelector = false
    @State private var showingReciterSelector = false
    @State private var showingTajweedInfo = false

    // MARK: - Content Section
    @ViewBuilder
    private var contentSection: some View {
        @Bindable var viewModel = viewModel
        
        VStack(spacing: 24) {
            ProfileSectionView(title: "Translation & Tafsir") {
                VStack(spacing: 0) {
                    resourceRow(
                        title: "Translation",
                        icon: "bubble.left.and.exclamationmark.bubble.right.fill",
                        currentValue: viewModel.selectedTranslation
                    ) {
                        showingTranslationSelector = true
                    }
                    
                    Divider().padding(.leading, 50).opacity(0.05)
                    
                    resourceRow(
                        title: "Tafsir Source",
                        icon: "book.closed.fill",
                        currentValue: viewModel.selectedTafsir
                    ) {
                        showingTafsirSelector = true
                    }
                }
            }
            
            ProfileSectionView(title: "Visibility Options") {
                VStack(spacing: 12) {
                    toggleRow(icon: "text.bubble", title: "Show Translation", isOn: $viewModel.showTranslation)
                    toggleRow(icon: "abc", title: "Show Transliteration", isOn: $viewModel.showTransliteration)
                    toggleRow(icon: "rectangle.grid.1x2.fill", title: "Word by Word", isOn: $viewModel.showWordByWord)
                    
                    // Tajweed Color Toggle with Info Button
                    let colors = appEnv.theme.current
                    ProfileMenuRow(icon: "paintpalette", title: "Tajweed Colors") {
                        HStack(spacing: 12) {
                            Button(action: { showingTajweedInfo = true }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(colors.primary)
                                    .font(.system(size: 20))
                            }
                            
                            Toggle("", isOn: $viewModel.showTajweed)
                                .tint(colors.primary)
                                .labelsHidden()
                        }
                    }
                }
            }
        }
    }
    
    private func resourceRow(title: String, icon: String, currentValue: String, action: @escaping () -> Void) -> some View {
        ProfileMenuRow(icon: icon, title: title, value: currentValue, showArrow: true, action: action)
    }
    
    // MARK: - Audio Section
    @ViewBuilder
    private var audioSection: some View {
        @Bindable var viewModel = viewModel
        
        VStack(spacing: 24) {
            ProfileSectionView(title: "Reciter Selection") {
                resourceRow(
                    title: "Active Reciter",
                    icon: "person.wave.2.fill",
                    currentValue: viewModel.selectedReciter
                ) {
                    showingReciterSelector = true
                }
            }
            
            ProfileSectionView(title: "Playback Settings") {
                VStack(spacing: 12) {
                    toggleRow(icon: "waveform.and.mic", title: "Enable Audio", isOn: $viewModel.audioEnabled)
                    toggleRow(icon: "waveform.circle.fill", title: "Word Audio", isOn: $viewModel.showWordAudio)
                    toggleRow(icon: "arrow.up.and.down.text.horizontal", title: "Auto-Scroll", isOn: $viewModel.autoScroll)
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func themeBox(name: String, icon: String, tag: String) -> some View {
        let colors = appEnv.theme.current
        let isSelected = viewModel.theme == tag
        
        return Button(action: { withAnimation { viewModel.theme = tag } }) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(name)
                    .font(.system(size: 13, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isSelected ? colors.primary.opacity(0.1) : colors.foreground.opacity(0.03))
            .foregroundColor(isSelected ? colors.primary : colors.foreground.opacity(0.5))
            .cornerRadius(16)
            .overlay {
                if isSelected {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(colors.primary.opacity(0.2), lineWidth: 1)
                }
            }
        }
    }
    
    private func toggleRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        let colors = appEnv.theme.current
        return ProfileMenuRow(icon: icon, title: title) {
            Toggle("", isOn: isOn)
                .tint(colors.primary)
                .labelsHidden()
        }
    }
    
    private func resourcePicker(title: String, icon: String, items: [(Int, String)], selection: Binding<Int>) -> some View {
        let colors = appEnv.theme.current
        return ProfileMenuRow(icon: icon, title: title) {
            Picker("", selection: selection) {
                if items.isEmpty && viewModel.isLoadingResources {
                    Text("Loading...").tag(selection.wrappedValue)
                } else {
                    ForEach(items, id: \.0) { id, name in
                        Text(name).tag(id)
                    }
                }
            }
            .pickerStyle(.menu)
            .tint(colors.primary)
        }
    }
}

