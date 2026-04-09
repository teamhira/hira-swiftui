//
//  QuranAyahListView.swift
//  Hira
//
//  Created by Antigravity on 08/04/26.
//

import SwiftUI

struct QuranAyahListView: View {
    let surah: Surah
    @Bindable var viewModel: QuranViewModel
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
    
    var body: some View {
        GeometryReader { outerGeo in
            ScrollViewReader { proxy in
                ZStack {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            // MARK: - Header
                            QuranHeritageHeader(surah: surah)
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                                .padding(.bottom, (surah.number == 1 || surah.number == 9) ? 40 : 0)
                            
                            if surah.number != 1 && surah.number != 9 {
                                bismillahHeader
                            }
                            
                            // MARK: - Verses
                            LazyVStack(spacing: 0) {
                                ForEach(viewModel.ayahs(for: surah)) { ayah in
                                    QuranAyahCard(ayah: ayah, viewModel: viewModel)
                                        .id(ayah.number)
                                }
                            }
                            
                            // Spacer pushes last ayah well above the floating mini player
                            Color.clear.frame(height: 180)
                            // Dedicated zero-height anchor at absolute bottom of content.
                            // Targeting this (not the Spacer) guarantees an accurate full-mentok scroll.
                            Color.clear.frame(height: 1)
                                .id("end_of_list")
                        }
                        // Single GeometryReader on entire content — fires ONCE per frame,
                        // eliminating the 'multiple times per frame' warning from LazyVStack.
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
                                // KEY FIX: Snapshot boundary state at the FIRST frame of a new touch.
                                // Navigation is ONLY allowed if the list was already resting at a
                                // boundary when the finger first touched — never from momentum carry-over.
                                if !isUserDragging {
                                    isUserDragging = true
                                    dragStartedAtTop = atTop
                                    dragStartedAtBottom = atBottom
                                }
                                
                                let v = gesture.translation.height
                                
                                // If user brings finger back toward center — cancel intent
                                if abs(v) < 15 {
                                    isReadyToTriggerNext = false
                                    isReadyToTriggerPrev = false
                                    pullDelta = 0
                                }
                                // Pull DOWN → Previous Surah (Gesture is v > 0)
                                else if v > 20 && dragStartedAtTop && atTop && currentSurah.number > 1 {
                                    pullDelta = v
                                    isReadyToTriggerPrev = pullDelta > 75
                                    isReadyToTriggerNext = false
                                }
                                // Pull UP → Next Surah (Gesture is v < 0)
                                else if v < -40 && dragStartedAtBottom && atBottom && currentSurah.number < viewModel.surahs.count {
                                    pullDelta = v // Keep raw negative value
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
                        // atTop: Content must be exactly at or above the top
                        atTop = frame.minY >= 0
                        // atBottom: Content must be exactly at or below the bottom
                        atBottom = frame.maxY <= outerGeo.size.height + 1
                    }
                    
                    // MARK: - Navigation Guidance (Transparent, Fixed Position)
                    VStack(spacing: 0) {
                        // TOP: Previous Surah guide — appears when pulling DOWN at top
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
                        
                        // BOTTOM: Next Surah guide — appears when pulling UP at bottom
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
                }
                .background(colors.background)
                .onAppear {
                    // CRITICAL: onAppear fires after the view is in the hierarchy.
                    // onChange(of: activeAyah) fires BEFORE this view exists (the picker sets
                    // activeAyah before PageCurlView creates this new surah's view).
                    // So we must re-check and scroll here on appear.
                    guard let ayah = viewModel.activeAyah,
                          currentSurah.number == surah.number,
                          ayah.surahNumber == surah.number else { return }
                    
                    scrollToAyah(ayah, proxy: proxy)
                }
                .onChange(of: viewModel.activeAyah) { _, newValue in
                    guard let ayah = newValue,
                          currentSurah.number == surah.number,
                          ayah.surahNumber == surah.number else { return }
                    
                    scrollToAyah(ayah, proxy: proxy)
                }
            }
        }
        .coordinateSpace(name: "outer_view")
    }
    
    // MARK: - Scroll Helper
    
    private func scrollToAyah(_ ayah: QuranAyah, proxy: ScrollViewProxy) {
        if ayah.number == surah.versesCount {
            // Delay allows LazyVStack to finish computing full content height.
            // Without delay, "end_of_list" position is not yet calculated correctly.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation(.easeInOut(duration: 0.35)) {
                    proxy.scrollTo("end_of_list", anchor: .bottom)
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring()) {
                    proxy.scrollTo(ayah.number, anchor: .center)
                }
            }
        }
    }

    
    // MARK: - Helper Methods
    
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
}

// MARK: - Preference Keys

/// Tracks the full content frame in a single update to avoid
/// 'multiple times per frame' warnings from LazyVStack.
private struct ContentFrameKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
