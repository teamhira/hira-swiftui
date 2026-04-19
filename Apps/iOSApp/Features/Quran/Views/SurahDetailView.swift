//
//  SurahDetailView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct SurahDetailView: View {
    @State var currentSurah: Surah
    @Environment(QuranViewModel.self) var viewModel
    @Environment(\.appEnvironment) var appEnv
    @Environment(\.dismiss) var dismiss
    
    @State var showingSurahPicker = false
    @State var showingAudioPlayer = false
    @State var pullUpOffset: CGFloat = 0
    @State var pullDownOffset: CGFloat = 0
    
    @State var currentPage: PageItem
    let allPages: [PageItem] = (1...604).map { PageItem(number: $0) }
    
    let initialAyah: QuranAyah?
    
    public init(surah: Surah, initialAyah: QuranAyah? = nil) {
        self.initialAyah = initialAyah
        _currentSurah = State(initialValue: surah)
        _currentPage = State(initialValue: PageItem(number: initialAyah?.pageNumber ?? surah.pages?.first ?? 1))
    }

    public var body: some View {
        let colors = appEnv.theme.current
        ZStack(alignment: .bottom) {
            colors.background
                .ignoresSafeArea()
            
            readerView
            
            if let toast = viewModel.toastMessage {
                VStack {
                    HiraToast(message: toast)
                        .padding(.top, 20)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(100)
            }
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
    
    var resolvedLanguage: String {
        let code = appEnv.language.selectedCode
        return code == "system" ? (Locale.current.language.languageCode?.identifier ?? "en") : code
    }
    
    func nextSurah() {
        let nextIndex = currentSurah.number
        guard nextIndex < viewModel.surahs.count else { return }
        currentSurah = viewModel.surahs[nextIndex]
    }
    
    func prevSurah() {
        let prevIndex = currentSurah.number - 2
        guard prevIndex >= 0, prevIndex < viewModel.surahs.count else { return }
        currentSurah = viewModel.surahs[prevIndex]
    }
}
