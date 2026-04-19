//
//  SurahDetailView+Modifiers.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI

struct SheetAndAlertModifiers: ViewModifier {
    @Binding var currentSurah: Surah
    @Binding var currentPage: PageItem
    @Binding var showingSurahPicker: Bool
    @Environment(QuranViewModel.self) var viewModel
    
    func body(content: Content) -> some View {
        @Bindable var viewModel = viewModel
        content
            .sheet(isPresented: $showingSurahPicker) {
                SurahPickerSheet(currentSurah: $currentSurah, currentPage: $currentPage)
            }
            .sheet(isPresented: $viewModel.showingSettings) {
                QuranSettingsSheet()
            }
            .sheet(isPresented: $viewModel.showingAyahOptions) {
                AyahOptionsSheet(ayah: viewModel.selectedAyah)
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $viewModel.showingInfo) {
                SurahInfoSheet(surah: currentSurah, info: viewModel.surahInfo)
            }
            .alert("Continue Auto Scroll?", isPresented: $viewModel.showingAutoScrollNextSurahAlert) {
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

struct LifecycleModifiers: ViewModifier {
    @Binding var currentSurah: Surah
    @Binding var currentPage: PageItem
    let initialAyah: QuranAyah?
    let resolvedLanguage: String
    @Environment(QuranViewModel.self) var viewModel
    
    func body(content: Content) -> some View {
        content
            .onChange(of: currentSurah) { oldValue, newValue in
                viewModel.startReadingSessionTracking()
                viewModel.surahInfo = nil
                viewModel.fetchAyahs(for: newValue, language: resolvedLanguage)
                viewModel.fetchSurahInfo(id: newValue.number, language: resolvedLanguage)
                viewModel.fetchSurahBookmarks(surah: newValue)
            }
            .onChange(of: currentPage) { oldValue, newValue in
                if viewModel.readingMode == .page {
                    let matchingSurah = viewModel.surahs.first(where: { surah in
                        guard let range = surah.pages, range.count >= 2 else { return false }
                        return (range[0]...range[1]).contains(newValue.number)
                    })
                    
                    if let s = matchingSurah, s.number != currentSurah.number {
                        currentSurah = s
                        if let firstAyah = viewModel.ayahsForPage(newValue.number).first(where: { $0.surahNumber == s.number }) {
                            viewModel.activeAyah = firstAyah
                        } else {
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
            .onChange(of: viewModel.activeAyah) { _, newValue in
                if let ayah = newValue {
                    viewModel.updateReadingSession(ayah: ayah)
                }
                
                if viewModel.readingMode == .page, let page = newValue?.pageNumber {
                    if page != currentPage.number {
                        currentPage = PageItem(number: page)
                    }
                }
            }
            .onAppear {
                viewModel.startReadingSessionTracking()
                if let ayah = initialAyah {
                    viewModel.activeAyah = ayah
                }
                viewModel.fetchAyahs(for: currentSurah, language: resolvedLanguage)
                viewModel.fetchSurahInfo(id: currentSurah.number, language: resolvedLanguage)
                viewModel.fetchSurahBookmarks(surah: currentSurah)
                if viewModel.readingMode == .page {
                    viewModel.fetchPage(currentPage.number)
                }
            }
            .onDisappear {
                viewModel.stopReadingSessionTracking()
            }
    }
}

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
