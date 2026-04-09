//
//  SurahDetailView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct SurahDetailView: View {
    @State private var currentSurah: Surah
    @State private var viewModel = QuranViewModel() 
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    public init(surah: Surah) {
        _currentSurah = State(initialValue: surah)
    }
    
    @State private var showingSurahPicker = false
    @State private var showingAudioPlayer = false
    @State private var pullUpOffset: CGFloat = 0
    @State private var pullDownOffset: CGFloat = 0

    public var body: some View {
        let colors = appEnv.theme.current
        ZStack(alignment: .bottom) {
            colors.background
                .ignoresSafeArea()
            
            // Native UIPageViewController with Vertical Scroll Transition
            PageCurlView(items: viewModel.surahs, currentItem: $currentSurah) { surah in
                surahContentView(for: surah)
                    .id(surah.id)
            }
            .id(viewModel.readingMode) // Force full refresh when reading mode changes
            .ignoresSafeArea()
        }
        .safeAreaInset(edge: .bottom) {
            miniAudioPlayer(colors: colors)
        }
        .fullScreenCover(isPresented: $showingAudioPlayer) {
            QuranAudioView(viewModel: viewModel, currentSurah: $currentSurah)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            titleToolbar(colors: colors)
            actionToolbar(colors: colors)
        }
        .background(SwipeBackDisabler())
        .sheet(isPresented: $showingSurahPicker) {
            SurahPickerSheet(currentSurah: $currentSurah, viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showingSettings) {
            QuranSettingsSheet(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showingAyahOptions) {
            AyahOptionsSheet(ayah: viewModel.selectedAyah, viewModel: viewModel)
                .presentationDetents([.medium, .large])
        }
        .alert("Surah Information", isPresented: $viewModel.showingInfo) {
            Button("Close", role: .cancel) { }
        } message: {
            Text("\(currentSurah.name) is surah number \(currentSurah.number) of the Quran. It has \(currentSurah.versesCount) verses and was revealed in \(currentSurah.revelationPlace).")
        }
        .onChange(of: currentSurah) { oldValue, newValue in
            // Only reset to first ayah if the CURRENT activeAyah doesn't belong to the NEW surah.
            // This allows the SurahPicker to set a specific ayah and have it persist.
            if let active = viewModel.activeAyah {
                let ayahsInNewSurah = viewModel.ayahs(for: newValue)
                if !ayahsInNewSurah.contains(where: { $0.id == active.id }) {
                    viewModel.activeAyah = ayahsInNewSurah.first
                }
            } else {
                viewModel.activeAyah = viewModel.ayahs(for: newValue).first
            }
        }
        .onAppear {
            if viewModel.activeAyah == nil {
                viewModel.activeAyah = viewModel.ayahs(for: currentSurah).first
            }
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private func surahContentView(for surah: Surah) -> some View {
        if viewModel.readingMode == .list {
            QuranAyahListView(
                surah: surah,
                viewModel: viewModel,
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
        } else {
            QuranMushafView(surah: surah, viewModel: viewModel)
        }
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
                        Text(currentSurah.name)
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
    
    // MARK: - Navigation Logic
    
    private func nextSurah() {
        let nextIndex = currentSurah.number
        if nextIndex < viewModel.surahs.count {
            currentSurah = viewModel.surahs[nextIndex]
        }
    }
    
    private func prevSurah() {
        let prevIndex = currentSurah.number - 2
        if prevIndex >= 0 {
            currentSurah = viewModel.surahs[prevIndex]
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
