//
//  QuranAudioView.swift
//  Hira
//
//  Created by Ryuk on 08/04/26.
//

import SwiftUI

public struct QuranAudioView: View {
    @Environment(QuranViewModel.self) private var viewModel
    @Binding var currentSurah: Surah
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingSettingsLocal = false
    @State private var isExpanded = false
    
    private let speeds: [Float] = [1.0, 1.5, 2.0, 0.5]
    private let repeatOptions = ["never", "1 time", "2 times", "3 times", "indefinitely"]
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    private var activeVerseKey: String? {
        viewModel.recitationManager.activeVerseKey
    }
    
    public var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                colors.background.ignoresSafeArea()
                
                ayahListView
                
                playerHUDView
                    .padding(.bottom, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                navigationToolbarItems(colors: colors)
            }
        }
        .onAppear {
            viewModel.fetchAyahs(for: currentSurah)
        }
        .onChange(of: activeVerseKey) { _, newValue in
            if let key = newValue, 
               let ayah = viewModel.ayahs(for: currentSurah).first(where: { "\($0.surahNumber):\($0.number)" == key }) {
                viewModel.activeAyah = ayah
            }
        }
        .sheet(isPresented: $showingSettingsLocal) {
            QuranSettingsSheet()
        }
    }
    
    // MARK: - Subviews
    
    private var ayahListView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 32) {
                    Spacer(minLength: 80)
                    
                    let ayahs = viewModel.ayahs(for: currentSurah)
                    let isLoading = viewModel.isAyahsLoading(for: currentSurah)
                    
                    if isLoading && ayahs.first?.isPlaceholder == true {
                        VStack(spacing: 20) {
                            ProgressView()
                            Text("Loading verses...")
                                .font(.system(size: 14))
                                .foregroundColor(colors.foreground.opacity(0.4))
                        }
                        .padding(.top, 100)
                    } else {
                        ForEach(ayahs) { ayah in
                            let isActive = viewModel.activeAyah?.id == ayah.id
                            AyahAudioRow(
                                ayah: ayah, 
                                isActive: isActive,
                                activeWordIndex: isActive ? viewModel.recitationManager.activeWordIndex : nil
                            )
                            .id(ayah.id)
                            .onTapGesture {
                                withAnimation { viewModel.activeAyah = ayah }
                            }
                        }
                    }
                    
                    Spacer(minLength: 200)
                }
            }
            .onChange(of: viewModel.activeAyah) { _, newValue in
                if let id = newValue?.id {
                    withAnimation { proxy.scrollTo(id, anchor: .center) }
                }
            }
        }
    }
    
    private var playerHUDView: some View {
        let manager = viewModel.recitationManager
        
        return VStack(spacing: 0) {
            // Floating Player Card
            VStack(spacing: isExpanded ? 20 : 12) {
                // Grabber / Toggle
                Capsule()
                    .fill(colors.foreground.opacity(0.1))
                    .frame(width: 36, height: 4)
                    .padding(.top, -8)
                    .padding(.bottom, 4)
                    .onTapGesture { withAnimation(.spring()) { isExpanded.toggle() } }

                if isExpanded {
                    // Info Section
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(currentSurah.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(colors.foreground)
                            if let ayah = viewModel.activeAyah {
                                Text("Ayah \(ayah.number)")
                                    .font(.system(size: 12))
                                    .foregroundColor(colors.primary)
                            }
                        }
                        .transition(.asymmetric(insertion: .push(from: .top).combined(with: .opacity), removal: .opacity))
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            speedSelector(manager: manager, colors: colors)
                            repeatSelector(colors: colors)
                        }
                        .transition(.asymmetric(insertion: .push(from: .trailing).combined(with: .opacity), removal: .opacity))
                    }
                    .padding(.horizontal, 8)
                }
                
                // Progress Section
                VStack(spacing: isExpanded ? 8 : 4) {
                    Slider(value: Binding(
                        get: { manager.currentTime },
                        set: { manager.seek(to: $0) }
                    ), in: 0...(manager.duration > 0 ? manager.duration : 1))
                    .tint(colors.primary)
                    .disabled(manager.duration <= 0)
                    .scaleEffect(isExpanded ? 1.0 : 0.95)
                    
                    if isExpanded {
                        HStack {
                            Text(formatTime(manager.currentTime))
                            Spacer()
                            Text(formatTime(manager.duration))
                        }
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(colors.foreground.opacity(0.4))
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal, isExpanded ? 0 : 8)
                
                // Control Section
                mainControls(manager: manager, colors: colors)
                    .scaleEffect(isExpanded ? 1.0 : 0.9)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, isExpanded ? 24 : 16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: isExpanded ? 32 : 40, style: .continuous))
            .shadow(color: Color.black.opacity(0.1), radius: 30, x: 0, y: 15)
            .padding(.horizontal, 20)
            .onTapGesture {
                if !isExpanded {
                    withAnimation(.spring()) { isExpanded = true }
                }
            }
        }
    }
    
    private func speedSelector(manager: any RecitationManager, colors: ThemeModel) -> some View {
        Menu {
            ForEach(speeds, id: \.self) { speed in
                Button("\(speed == 1.0 ? "Normal" : String(format: "%.1fx", speed))") {
                    viewModel.recitationManager.playbackRate = speed
                }
            }
        } label: {
            Text(String(format: "%.1fx", manager.playbackRate))
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(colors.primary.opacity(0.1))
                .foregroundColor(colors.primary)
                .clipShape(Capsule())
        }
    }
    
    private func mainControls(manager: any RecitationManager, colors: ThemeModel) -> some View {
        HStack(spacing: 36) {
            // Prev Surah
            Button(action: { prevSurah() }) {
                Image(systemName: "backward.end.fill")
                    .font(.system(size: 18))
            }
            .disabled(currentSurah.number <= 1)
            
            // Prev Ayah
            Button(action: { prevAyah() }) {
                Image(systemName: "backward.fill")
                    .font(.system(size: 24))
            }
            
            // Play/Pause
            Button(action: { 
                // Don't do anything if ayahs are literally in middle of fetching
                if viewModel.isAyahsLoading(for: currentSurah) && viewModel.ayahs(for: currentSurah).first?.isPlaceholder == true {
                    return
                }
                
                if manager.status == .playing || manager.status == .paused {
                    manager.togglePlayPause()
                } else {
                    // This handles idle/error/loading cases
                    viewModel.playCurrentSurah(surah: currentSurah)
                }
            }) {
                ZStack {
                    Circle()
                        .fill(colors.primary)
                        .frame(width: 64, height: 64)
                    
                    let isAudioLoading = manager.status == .loading
                    let isDataLoading = viewModel.isAyahsLoading(for: currentSurah) && viewModel.ayahs(for: currentSurah).first?.isPlaceholder == true
                    
                    if isAudioLoading || isDataLoading {
                        ProgressView().tint(.white)
                    } else {
                        Image(systemName: manager.status == .playing ? "pause.fill" : "play.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }
                }
            }
            
            // Next Ayah
            Button(action: { nextAyah() }) {
                Image(systemName: "forward.fill")
                    .font(.system(size: 24))
            }
            
            // Next Surah
            Button(action: { nextSurah() }) {
                Image(systemName: "forward.end.fill")
                    .font(.system(size: 18))
            }
            .disabled(currentSurah.number >= viewModel.surahs.count)
        }
        .foregroundColor(colors.foreground)
    }
    
    private func repeatSelector(colors: ThemeModel) -> some View {
        Menu {
            Picker("Repeat", selection: Binding(
                get: { viewModel.recitationManager.repeatMode },
                set: { viewModel.recitationManager.repeatMode = $0 }
            )) {
                ForEach(repeatOptions, id: \.self) { option in
                    Text(option.capitalized).tag(option)
                }
            }
        } label: {
            let mode = viewModel.recitationManager.repeatMode
            Image(systemName: mode == "never" ? "repeat" : "repeat.1")
                .font(.system(size: 14, weight: .bold))
                .padding(8)
                .background(colors.primary.opacity(0.1))
                .foregroundColor(colors.primary)
                .clipShape(Circle())
        }
    }
    
    @ToolbarContentBuilder
    private func navigationToolbarItems(colors: ThemeModel) -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.down")
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(colors.foreground.opacity(0.5))
        }
        
        ToolbarItem(placement: .principal) {
            VStack(spacing: 0) {
                Text(currentSurah.name)
                    .font(.headline)
                Text("Recitation")
                    .font(.system(size: 10))
                    .foregroundColor(colors.primary)
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: { showingSettingsLocal = true }) {
                Image(systemName: "ellipsis.circle")
            }
            .foregroundColor(colors.foreground)
        }
    }
    
    private func formatTime(_ seconds: Double) -> String {
        guard !seconds.isNaN && !seconds.isInfinite else { return "00:00" }
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    private func nextAyah() {
        let ayahs = viewModel.ayahs(for: currentSurah)
        guard let current = viewModel.activeAyah,
              let index = ayahs.firstIndex(where: { $0.id == current.id }) else { return }
        
        if index < ayahs.count - 1 {
            let next = ayahs[index + 1]
            viewModel.activeAyah = next
            viewModel.playCurrentSurah(surah: currentSurah)
        } else {
            // End of surah, go to next surah
            nextSurah()
        }
    }
    
    private func prevAyah() {
        let ayahs = viewModel.ayahs(for: currentSurah)
        guard let current = viewModel.activeAyah,
              let index = ayahs.firstIndex(where: { $0.id == current.id }) else { return }
        
        if index > 0 {
            let prev = ayahs[index - 1]
            viewModel.activeAyah = prev
            viewModel.playCurrentSurah(surah: currentSurah)
        } else {
            // Start of surah, go to prev surah
            prevSurah()
        }
    }
    
    private func nextSurah() {
        let allSurahs = viewModel.surahs
        guard let index = allSurahs.firstIndex(where: { $0.number == currentSurah.number }) else { return }
        
        if index < allSurahs.count - 1 {
            let next = allSurahs[index + 1]
            currentSurah = next
            viewModel.fetchAyahs(for: next)
            viewModel.playCurrentSurah(surah: next)
        }
    }
    
    private func prevSurah() {
        let allSurahs = viewModel.surahs
        guard let index = allSurahs.firstIndex(where: { $0.number == currentSurah.number }) else { return }
        
        if index > 0 {
            let prev = allSurahs[index - 1]
            currentSurah = prev
            viewModel.fetchAyahs(for: prev)
            viewModel.playCurrentSurah(surah: prev)
        }
    }
}

struct AyahAudioRow: View {
    let ayah: QuranAyah
    let isActive: Bool
    var activeWordIndex: Int?
    
    @Environment(QuranViewModel.self) private var viewModel
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        let colors = appEnv.theme.current
        VStack(alignment: .leading, spacing: 20) {
            // Arabic Text - Explicitly Trailing for Audio View
            HStack {
                Spacer()
                QuranFlowLayout(spacing: 12) {
                    let wordsToProcess = ayah.words.filter { $0.charTypeName != "end" && $0.text?.rangeOfCharacter(from: .decimalDigits) == nil }
                    
                    ForEach(Array(wordsToProcess.enumerated()), id: \.offset) { index, word in
                        let isWordActive = isActive && activeWordIndex == (index + 1)
                        let content = renderWord(word)
                        let hasTajweed = viewModel.showTajweed && word.textTajweed != nil
                        
                        Text(content)
                            .font(.custom("KFGQPC Uthman Taha Naskh", size: viewModel.textSize * 1.07))
                            .foregroundColor(isWordActive ? colors.primary : (hasTajweed ? nil : colors.foreground))
                            .background(isWordActive ? colors.primary.opacity(0.15) : Color.clear)
                    }
                    
                    Text("﴾\(String(ayah.number).convertedToArabic())﴿")
                        .font(.custom("KFGQPC Uthman Taha Naskh", size: viewModel.textSize * 0.8))
                        .foregroundColor(colors.primary)
                }
                .environment(\.layoutDirection, .rightToLeft)
            }
            .padding(.horizontal, 24)
            
            // Info Section (Latin & Translation) - Explicitly Leading
            VStack(alignment: .leading, spacing: 10) {
                if viewModel.showTransliteration {
                    Text(ayah.textLatin)
                        .font(.system(size: max(13, viewModel.textSize * 0.5), weight: .semibold, design: .serif))
                        .foregroundColor(colors.primary.opacity(0.7))
                        .italic()
                        .multilineTextAlignment(.leading)
                }
                
                Text(ayah.translation)
                    .font(.system(size: max(14, viewModel.textSize * 0.55)))
                    .foregroundColor(colors.foreground.opacity(isActive ? 0.9 : 0.6))
                    .lineSpacing(viewModel.textSize * 0.15)
                    .multilineTextAlignment(.leading)
                    .opacity(isActive ? 1.0 : 0.8)
            }
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 30)
        .background(
            ZStack {
                if isActive {
                    colors.primary.opacity(0.08)
                }
            }
        )
        .scaleEffect(isActive ? 1.02 : 1.0)
        .animation(.spring(), value: isActive)
    }
    
    private func renderWord(_ word: Word) -> AttributedString {
        if viewModel.showTajweed, let html = word.textTajweed {
            return TajweedRenderer.render(html: html)
        } else {
            return AttributedString(word.text ?? "")
        }
    }
}
