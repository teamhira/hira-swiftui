//
//  SurahDetailView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct SurahDetailView: View {
    @State private var currentSurah: Surah
    @Environment(QuranViewModel.self) private var viewModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingSurahPicker = false
    @State private var showingAudioPlayer = false
    @State private var pullUpOffset: CGFloat = 0
    @State private var pullDownOffset: CGFloat = 0
    
    @State private var currentPage: PageItem
    private let allPages: [PageItem] = (1...604).map { PageItem(number: $0) }
    
    private let initialAyah: QuranAyah?
    
    public init(surah: Surah, initialAyah: QuranAyah? = nil) {
        self.initialAyah = initialAyah
        _currentSurah = State(initialValue: surah)
        _currentPage = State(initialValue: PageItem(number: initialAyah?.pageNumber ?? surah.pages?.first ?? 1))
    }

    public var body: some View {
        @Bindable var viewModel = viewModel
        let colors = appEnv.theme.current
        ZStack(alignment: .bottom) {
            colors.background
                .ignoresSafeArea()
            
            readerView
        }
        .safeAreaInset(edge: .bottom) {
            bottomControls(colors: colors)
        }
        .fullScreenCover(isPresented: $showingAudioPlayer) {
            QuranAudioView(currentSurah: $currentSurah)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            titleToolbar(colors: colors)
            actionToolbar(colors: colors)
        }
        .background(SwipeBackDisabler())
        .modifier(SheetAndAlertModifiers(currentSurah: $currentSurah, currentPage: $currentPage, showingSurahPicker: $showingSurahPicker))
        .modifier(LifecycleModifiers(currentSurah: $currentSurah, currentPage: $currentPage, initialAyah: initialAyah, resolvedLanguage: resolvedLanguage))
    }
    
    @ViewBuilder
    private func bottomControls(colors: ThemeModel) -> some View {
        VStack(alignment: .trailing, spacing: 12) {
            if viewModel.autoScroll {
                HStack {
                    Spacer()
                    autoScrollIndicator(colors: colors)
                        .padding(.trailing, 24)
                }
            }
            miniAudioPlayer(colors: colors)
        }
    }

    @ViewBuilder
    private var readerView: some View {
        if viewModel.readingMode == .list {
            PageCurlView(items: viewModel.surahs, currentItem: $currentSurah) { surah in
                surahContentView(for: surah)
                    .environment(viewModel)
                    .environment(\.appEnvironment, appEnv)
                    .id("list_\(surah.id)")
            }
            .id("list_mode")
            .ignoresSafeArea()
        } else {
            PageCurlView(items: allPages, currentItem: $currentPage) { page in
                QuranMushafView(pageNumber: page.number)
                    .environment(viewModel)
                    .environment(\.appEnvironment, appEnv)
                    .id("mushaf_\(page.number)")
            }
            .id("mushaf_mode")
            .ignoresSafeArea()
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private func surahContentView(for surah: Surah) -> some View {
        QuranAyahListView(
            surah: surah,
            currentSurah: $currentSurah,
            pullUpOffset: $pullUpOffset,
            pullDownOffset: $pullDownOffset,
            onNextSurah: {
                withAnimation(.easeInOut) {
                    nextSurah()
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                }
            },
            onPrevSurah: {
                withAnimation(.easeInOut) {
                    prevSurah()
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                }
            }
        )
    }
    
    @ViewBuilder
    private func autoScrollIndicator(colors: ThemeModel) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.green)
                .frame(width: 8, height: 8)
                // We fake a pulse by using an implicit opacity animation bound to an alternating state
                .opacity(0.8)
            
            Text("Auto Play")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(colors.foreground)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity))
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.autoScroll)
    }
    
    @ViewBuilder
    private func miniAudioPlayer(colors: ThemeModel) -> some View {
        if let activeAyah = viewModel.activeAyah {
            Button(action: { showingAudioPlayer = true }) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(colors.primary.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Image(systemName: "waveform")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(colors.primary)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        let activeSurah = viewModel.surahs.first(where: { $0.number == activeAyah.surahNumber })
                        Text(activeSurah?.name ?? currentSurah.name)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(colors.foreground)
                        Text("Verses \(activeAyah.number)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(colors.primary.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 14) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 18))
                            .foregroundColor(colors.primary)
                        
                        Image(systemName: "chevron.up")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(colors.foreground.opacity(0.3))
                    }
                }
                .padding(.leading, 8)
                .padding(.trailing, 20)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
                .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 8)
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
    
    private func titleToolbar(colors: ThemeModel) -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .principal) {
            Button(action: { showingSurahPicker = true }) {
                HStack(spacing: 4) {
                    Text(currentSurah.name)
                        .font(.system(size: 17, weight: .semibold))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(colors.foreground)
            }
        }
    }
    
    private func actionToolbar(colors: ThemeModel) -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: 12) {
                Button(action: { 
                    viewModel.toggleAutoScroll(for: currentSurah)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }) {
                    if viewModel.autoScroll {
                        Image(systemName: "scroll.fill")
                            .foregroundColor(colors.primary)
                    } else {
                        Image(systemName: "scroll")
                            .foregroundColor(colors.foreground)
                    }
                }
                .help("Auto Scroll")
                
                Button(action: { viewModel.showingInfo = true }) {
                    Image(systemName: "info.circle")
                }
                Button(action: { viewModel.showingSettings = true }) {
                    Image(systemName: "gearshape")
                }
            }
            .foregroundColor(colors.foreground)
        }
    }
    
    // MARK: - Language Helper
    
    private var resolvedLanguage: String {
        let code = appEnv.language.selectedCode
        if code == "system" {
            return Locale.current.language.languageCode?.identifier ?? "en"
        }
        return code
    }
    
    // MARK: - Navigation Logic
    
    private func nextSurah() {
        let nextIndex = currentSurah.number
        guard nextIndex < viewModel.surahs.count else { return }
        currentSurah = viewModel.surahs[nextIndex]
    }
    
    private func prevSurah() {
        let prevIndex = currentSurah.number - 2
        guard prevIndex >= 0, prevIndex < viewModel.surahs.count else { return }
        currentSurah = viewModel.surahs[prevIndex]
    }
}

// MARK: - Helper Modifiers to reduce body complexity
private struct SheetAndAlertModifiers: ViewModifier {
    @Binding var currentSurah: Surah
    @Binding var currentPage: PageItem
    @Binding var showingSurahPicker: Bool
    @Environment(QuranViewModel.self) private var viewModel
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showingSurahPicker) {
                SurahPickerSheet(currentSurah: $currentSurah, currentPage: $currentPage)
            }
            .sheet(isPresented: Bindable(viewModel).showingSettings) {
                QuranSettingsSheet()
            }
            .sheet(isPresented: Bindable(viewModel).showingAyahOptions) {
                AyahOptionsSheet(ayah: viewModel.selectedAyah)
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: Bindable(viewModel).showingInfo) {
                SurahInfoSheet(surah: currentSurah, info: viewModel.surahInfo)
            }
            .alert("Continue Auto Scroll?", isPresented: Bindable(viewModel).showingAutoScrollNextSurahAlert) {
                Button("Cancel", role: .cancel) {
                    viewModel.autoScroll = false
                }
                Button("Continue") {
                    if let next = viewModel.autoScrollNextSurah {
                        withAnimation(.easeInOut) {
                            currentSurah = next
                        }
                        viewModel.startTeleprompter(for: next)
                    }
                }
            } message: {
                if let next = viewModel.autoScrollNextSurah {
                    Text("Do you want to continue reading \(next.name)?")
                }
            }
    }
}

private struct LifecycleModifiers: ViewModifier {
    @Binding var currentSurah: Surah
    @Binding var currentPage: PageItem
    let initialAyah: QuranAyah?
    let resolvedLanguage: String
    @Environment(QuranViewModel.self) private var viewModel
    
    func body(content: Content) -> some View {
        content
            .onChange(of: currentSurah) { oldValue, newValue in
                viewModel.surahInfo = nil
                viewModel.fetchAyahs(for: newValue, language: resolvedLanguage)
                viewModel.fetchSurahInfo(id: newValue.number, language: resolvedLanguage)
            }
            .onChange(of: currentPage) { oldValue, newValue in
                if viewModel.readingMode == .page {
                    // Try fast lookup using surah metadata ranges first
                    let matchingSurah = viewModel.surahs.first(where: { surah in
                        guard let range = surah.pages, range.count >= 2 else { return false }
                        return (range[0]...range[1]).contains(newValue.number)
                    })
                    
                    if let s = matchingSurah, s.number != currentSurah.number {
                        currentSurah = s
                        
                        // Also update active ayah to the first ayah of the new surah
                        // for better "responsiveness" between pages
                        if let firstAyah = viewModel.ayahsForPage(newValue.number).first(where: { $0.surahNumber == s.number }) {
                            viewModel.activeAyah = firstAyah
                        } else {
                            // Fallback: Use Surah number and Ayah 1 as a placeholder
                            viewModel.activeAyah = QuranAyah(
                                surahNumber: s.number,
                                number: 1,
                                textArabic: "",
                                textLatin: "",
                                translation: "",
                                words: [],
                                audio: nil,
                                pageNumber: newValue.number,
                                juzNumber: 1,
                                isPlaceholder: true
                            )
                        }
                    } else if matchingSurah == nil {
                        // Fallback to verse cache if metadata ranges are missing
                        if let ayahs = viewModel.ayahsForPage(newValue.number).first,
                           let s = viewModel.surahs.first(where: { $0.number == ayahs.surahNumber }),
                           s.number != currentSurah.number {
                            currentSurah = s
                            viewModel.activeAyah = ayahs
                        }
                    }
                }
            }
            .onChange(of: viewModel.readingMode) {
                if viewModel.readingMode == .page {
                    currentPage = PageItem(number: currentSurah.pages?.first ?? 1)
                } else {
                    if let snum = viewModel.ayahsForPage(currentPage.number).first?.surahNumber, 
                       let s = viewModel.surahs.first(where: { $0.number == snum }) {
                        currentSurah = s
                    }
                }
            }
            .onAppear {
                if let ayah = initialAyah {
                    viewModel.activeAyah = ayah
                }
                viewModel.fetchAyahs(for: currentSurah, language: resolvedLanguage)
                viewModel.fetchSurahInfo(id: currentSurah.number, language: resolvedLanguage)
                if viewModel.readingMode == .page {
                    viewModel.fetchPage(currentPage.number)
                }
            }
    }
}

// MARK: - UIKit Helper to Disable Swipe Back
struct SwipeBackDisabler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        DispatchQueue.main.async {
            vc.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct PageItem: Identifiable, Equatable {
    let number: Int
    var id: Int { number }
}
