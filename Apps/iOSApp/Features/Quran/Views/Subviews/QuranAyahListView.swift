//
//  QuranAyahListView.swift
//  Hira
//
//  Created by Ryuk on 08/04/26.
//

import SwiftUI

struct QuranAyahListView: View {
    let surah: Surah
    @Environment(QuranViewModel.self) private var viewModel
    @Binding var currentSurah: Surah
    @Binding var pullUpOffset: CGFloat
    @Binding var pullDownOffset: CGFloat
    
    let onNextSurah: () -> Void
    let onPrevSurah: () -> Void
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    // Navigation state
    @State private var isReadyToTriggerNext = false
    @State private var isReadyToTriggerPrev = false
    @State private var isUserDragging = false
    @State private var pullDelta: CGFloat = 0
    
    // Live scroll edge detection
    @State private var atTop = false
    @State private var atBottom = false
    
    // Captured at start of each individual drag touch
    @State private var dragStartedAtTop = false
    @State private var dragStartedAtBottom = false
    
    // Skeleton shimmer animation
    @State private var shimmerOpacity: Double = 0.4
    
    var body: some View {
        GeometryReader { outerGeo in
            ScrollViewReader { proxy in
                ZStack {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            // MARK: - Header
                            QuranHeritageHeader(surah: surah, juzNumber: viewModel.ayahs(for: surah).first?.juzNumber)
                                .id("surah_header")
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                                .padding(.bottom, (surah.number == 1 || surah.number == 9) ? 40 : 0)
                            
                            if surah.number != 1 && surah.number != 9 {
                                bismillahHeader
                            }
                            
                            // MARK: - Verses
                            VStack(spacing: 0) {
                                ForEach(viewModel.ayahs(for: surah)) { ayah in
                                    if ayah.isPlaceholder {
                                        ayahSkeleton
                                    } else {
                                        QuranAyahCard(ayah: ayah, viewModel: viewModel)
                                            .id(ayah.id)
                                    }
                                }
                            }
                            
                            // Spacer pushes last ayah well above the floating mini player
                            Color.clear.frame(height: 180)
                            
                            // Dedicated zero-height anchor at absolute bottom of content.
                            Color.clear.frame(height: 1)
                                .id("end_of_list")
                        }
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: ContentFrameKey.self,
                                    value: geo.frame(in: .named("outer_view"))
                                )
                            }
                        )
                    }
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 15)
                            .onChanged { gesture in
                                if !isUserDragging {
                                    isUserDragging = true
                                    dragStartedAtTop = atTop
                                    dragStartedAtBottom = atBottom
                                }
                                
                                let v = gesture.translation.height
                                
                                if abs(v) < 15 {
                                    isReadyToTriggerNext = false
                                    isReadyToTriggerPrev = false
                                    pullDelta = 0
                                }
                                else if v > 20 && dragStartedAtTop && atTop && currentSurah.number > 1 {
                                    pullDelta = v
                                    isReadyToTriggerPrev = pullDelta > 75
                                    isReadyToTriggerNext = false
                                }
                                else if v < -40 && dragStartedAtBottom && atBottom && currentSurah.number < viewModel.surahs.count {
                                    pullDelta = v
                                    isReadyToTriggerNext = abs(pullDelta) > 110
                                    isReadyToTriggerPrev = false
                                } else {
                                    pullDelta = 0
                                    isReadyToTriggerNext = false
                                    isReadyToTriggerPrev = false
                                }
                            }
                            .onEnded { gesture in
                                let predictedSpeed = abs(gesture.predictedEndTranslation.height)
                                if predictedSpeed > 300 {
                                    resetNavigationState()
                                } else {
                                    handleGestureEnd()
                                }
                            }
                    )
                    .onPreferenceChange(ContentFrameKey.self) { frame in
                        atTop = frame.minY >= 0
                        atBottom = frame.maxY <= outerGeo.size.height + 1
                    }
                    
                    // Navigation Guidance
                    VStack(spacing: 0) {
                        if isUserDragging && dragStartedAtTop && atTop && pullDelta > 30 && currentSurah.number > 1 {
                            VStack(spacing: 6) {
                                QuranNavigationIndicator(
                                    offset: pullDelta,
                                    isTop: true,
                                    targetSurah: viewModel.surahs[max(0, currentSurah.number - 2)],
                                    colors: colors
                                )
                                Text(pullDelta > 70 ? "Release to switch" : "Pull down to switch")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(colors.primary.opacity(0.4))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 12)
                            .transition(.opacity)
                        }
                        
                        Spacer()
                        
                        if isUserDragging && dragStartedAtBottom && atBottom && pullDelta < -30 && currentSurah.number < viewModel.surahs.count {
                            VStack(spacing: 6) {
                                QuranNavigationIndicator(
                                    offset: abs(pullDelta),
                                    isTop: false,
                                    targetSurah: viewModel.surahs[min(viewModel.surahs.count - 1, currentSurah.number)],
                                    colors: colors
                                )
                                Text(abs(pullDelta) > 100 ? "Release to switch" : "Pull up to switch")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(colors.primary.opacity(0.4))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 140)
                            .transition(.opacity)
                        }
                    }
                    .allowsHitTesting(false)
                }
                .background(colors.background)
                .onAppear {
                    // Pre-fetch if needed
                    viewModel.fetchAyahs(for: surah, language: currentLanguage)
                    
                    // Sync active ayah to first verse if not already in this surah
                    if viewModel.activeAyah?.surahNumber != surah.number {
                        let ayahs = viewModel.ayahs(for: surah)
                        if let first = ayahs.first, !first.isPlaceholder {
                            viewModel.activeAyah = first
                        }
                    }
                    
                    // Delay slightly to allow layout to settle
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if let ayah = viewModel.activeAyah,
                           currentSurah.number == surah.number,
                           ayah.surahNumber == surah.number {
                            scrollToAyah(ayah, proxy: proxy, animated: false)
                        } else {
                            // Default to top (header)
                            withAnimation(.spring()) {
                                proxy.scrollTo("surah_header", anchor: .top)
                            }
                        }
                    }
                }
                .onChange(of: surah) { _, newSurah in
                    // When surah changes, immediately reset active ayah to the first verse of the new surah.
                    let ayahs = viewModel.ayahs(for: newSurah)
                    if let first = ayahs.first, !first.isPlaceholder {
                        withAnimation {
                            viewModel.activeAyah = first
                        }
                    }
                }
                .onChange(of: viewModel.activeAyah) { _, newValue in
                    guard viewModel.autoScroll else { return }
                    guard let ayah = newValue,
                          currentSurah.number == surah.number,
                          ayah.surahNumber == surah.number else { return }
                    
                    scrollToAyah(ayah, proxy: proxy, animated: true)
                }
                .onChange(of: viewModel.autoScroll) { _, newValue in
                    if newValue, let ayah = viewModel.activeAyah,
                       currentSurah.number == surah.number,
                       ayah.surahNumber == surah.number {
                        scrollToAyah(ayah, proxy: proxy, animated: true)
                    }
                }
                .onChange(of: viewModel.ayahs(for: surah)) { _, newAyahs in
                    // If we have a target active ayah that belongs to this surah,
                    // re-scroll once real data replaces shells.
                    if viewModel.autoScroll, let active = viewModel.activeAyah, active.surahNumber == surah.number {
                        scrollToAyah(active, proxy: proxy, animated: true)
                    }
                    
                    // NEW: If there's no active ayah in this surah yet, and we just got the real data,
                    // auto-activate the first ayah.
                    if viewModel.activeAyah?.surahNumber != surah.number {
                        if let first = newAyahs.first, !first.isPlaceholder {
                            withAnimation(.easeInOut) {
                                viewModel.activeAyah = first
                            }
                        }
                    }
                }
            }
        }
        .coordinateSpace(name: "outer_view")
    }
    
    // MARK: - Helpers
    
    private func scrollToAyah(_ ayah: QuranAyah, proxy: ScrollViewProxy, animated: Bool = true) {
        let work = {
            if ayah.number == surah.versesCount {
                proxy.scrollTo("end_of_list", anchor: .bottom)
            } else {
                proxy.scrollTo(ayah.id, anchor: .center)
            }
        }
        
        if animated {
            // Use slow easeInOut for "perlahan" feel as requested
            withAnimation(.easeInOut(duration: 0.8)) { work() }
        } else {
            work()
        }
    }
    
    private var currentLanguage: String {
        let code = appEnv.language.selectedCode
        if code == "system" {
            return Locale.current.language.languageCode?.identifier ?? "en"
        }
        return code
    }
    
    private func handleGestureEnd() {
        if isReadyToTriggerNext && dragStartedAtBottom {
            onNextSurah()
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        } else if isReadyToTriggerPrev && dragStartedAtTop {
            onPrevSurah()
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
        resetNavigationState()
    }
    
    private func resetNavigationState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring()) {
                isUserDragging = false
                isReadyToTriggerNext = false
                isReadyToTriggerPrev = false
                pullDelta = 0
                dragStartedAtTop = false
                dragStartedAtBottom = false
            }
        }
    }
    
    // MARK: - Subviews
    
    private var ayahSkeleton: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Verse Header Placeholder
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(colors.foreground.opacity(0.04))
                    .frame(width: 40, height: 10)
                Spacer()
                RoundedRectangle(cornerRadius: 4)
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 60, height: 24)
            }
            .environment(\.layoutDirection, .leftToRight)
            
            // Arabic Text Placeholder
            HStack {
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(colors.foreground.opacity(0.06))
                        .frame(width: CGFloat.random(in: 200...300), height: 32)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(colors.foreground.opacity(0.04))
                        .frame(width: CGFloat.random(in: 150...250), height: 32)
                }
            }
            .environment(\.layoutDirection, .rightToLeft)
            
            // Translation/Transliteration Placeholder
            VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(colors.primary.opacity(0.05))
                    .frame(width: 140, height: 12)
                
                VStack(alignment: .leading, spacing: 6) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(colors.foreground.opacity(0.04))
                        .frame(maxWidth: .infinity)
                        .frame(height: 12)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(colors.foreground.opacity(0.03))
                        .frame(width: 200, height: 12)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(colors.background)
        .redacted(reason: .placeholder)
        .opacity(shimmerOpacity)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                shimmerOpacity = 0.8
            }
        }
    }
    
    private var bismillahHeader: some View {
        HStack(spacing: 15) {
            lineDivider(isLeading: true).frame(maxWidth: 80)
            Text("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ")
                .font(.custom("KFGQPC Uthman Taha Naskh", size: 24))
                .foregroundColor(colors.foreground)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .layoutPriority(1)
            lineDivider(isLeading: false).frame(maxWidth: 80)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
    }
    
    private func lineDivider(isLeading: Bool) -> some View {
        HStack(spacing: 0) {
            if !isLeading {
                Image(systemName: "rhombus.fill")
                    .font(.system(size: 6))
                    .foregroundColor(colors.primary.opacity(0.3))
                    .rotationEffect(.degrees(45))
                    .padding(.trailing, 8)
            }
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        colors.primary.opacity(0),
                        colors.primary.opacity(0.4)
                    ]),
                    startPoint: isLeading ? .leading : .trailing,
                    endPoint: isLeading ? .trailing : .leading
                ))
                .frame(height: 1)
            if isLeading {
                Image(systemName: "rhombus.fill")
                    .font(.system(size: 6))
                    .foregroundColor(colors.primary.opacity(0.3))
                    .rotationEffect(.degrees(45))
                    .padding(.leading, 8)
            }
        }
    }

    private struct ContentFrameKey: PreferenceKey {
        static var defaultValue: CGRect = .zero
        static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
            value = nextValue()
        }
    }
}
