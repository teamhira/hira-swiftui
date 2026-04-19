//
//  QuranJuzDetailView.swift
//  Hira
//
//  Created by Ryuk on 12/04/26.
//

import SwiftUI

public struct QuranJuzDetailView: View {
    let juz: JuzProgress
    @Environment(QuranViewModel.self) private var viewModel
    @Environment(AppRouter.self) private var router
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedSurah: Surah?
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    // Parse surahs from verseMapping
    private var surahsInJuz: [Surah] {
        let surahIds = juz.verseMapping.keys.compactMap { Int($0) }.sorted()
        return surahIds.compactMap { id in
            viewModel.surahs.first(where: { $0.number == id })
        }
    }
    
    public var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                colors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        // Header Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text(String(format: appEnv.language.localizedString("quran_juz_number"), juz.number))
                                .font(.system(size: 34, weight: .bold, design: .serif))
                                .foregroundColor(colors.primary)
                            
                            Text(juz.surahRange)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(colors.foreground.opacity(0.6))
                            
                            Rectangle()
                                .fill(colors.primary.opacity(0.2))
                                .frame(width: 40, height: 2)
                                .padding(.top, 4)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        
                        // Description
                        Text(appEnv.language.localizedString(juz.descriptionKey))
                            .font(.system(size: 14))
                            .lineSpacing(6)
                            .foregroundColor(colors.foreground.opacity(0.7))
                            .padding(.horizontal, 24)
                        
                        // Surah List
                        LazyVStack(spacing: 12) {
                            ForEach(surahsInJuz) { surah in
                                NavigationLink(value: surah) {
                                    JuzSurahRow(surah: surah, juz: juz)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(colors.primary)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(String(format: appEnv.language.localizedString("quran_juz_number"), juz.number))
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(colors.foreground)
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationDestination(for: Surah.self) { surah in
                JuzAyahPickerView(surah: surah, juz: juz) { selectedAyah in
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        router.navigate(to: .surahDetail(surah, ayah: selectedAyah))
                    }
                }
            }
        }
    }
}

struct JuzSurahRow: View {
    let surah: Surah
    let juz: JuzProgress
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 44, height: 44)
                Text("\(surah.number)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(colors.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(surah.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(colors.foreground)
                if let range = juz.verseMapping[String(surah.number)] {
                    Text("Verses \(range)")
                        .font(.system(size: 12))
                        .foregroundColor(colors.foreground.opacity(0.5))
                }
            }
            
            Spacer()
            
            Text(surah.nameArabic)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(colors.primary)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 24).fill(colors.foreground.opacity(0.04)))
    }
}

struct JuzAyahPickerView: View {
    let surah: Surah
    let juz: JuzProgress
    let onSelect: (QuranAyah) -> Void
    @Environment(QuranViewModel.self) private var viewModel
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    private var restrictedAyahs: [QuranAyah] {
        guard let rangeStr = juz.verseMapping[String(surah.number)] else { return [] }
        let parts = rangeStr.split(separator: "-")
        guard parts.count == 2, let start = Int(parts[0]), let end = Int(parts[1]) else { return [] }
        
        let allAyahs = viewModel.ayahs(for: surah)
        return allAyahs.filter { $0.number >= start && $0.number <= end }
    }
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Text(surah.name)
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundColor(colors.primary)
                        
                        Text("Select a verse from Juz \(juz.number)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(colors.foreground.opacity(0.4))
                        
                        Rectangle()
                            .fill(colors.primary.opacity(0.2))
                            .frame(width: 40, height: 2)
                            .padding(.top, 4)
                    }
                    .padding(.top, 24)
                    
                    if viewModel.isAyahsLoading(for: surah) && viewModel.ayahCache[surah.number] == nil {
                        ProgressView().padding(.top, 40)
                    } else {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5), spacing: 12) {
                            ForEach(restrictedAyahs) { ayah in
                                Button(action: { onSelect(ayah) }) {
                                    Text("\(ayah.number)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(colors.foreground)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 54)
                                        .background(RoundedRectangle(cornerRadius: 16).fill(colors.primary.opacity(0.06)))
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationTitle(surah.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.ayahCache[surah.number] == nil {
                viewModel.fetchAyahs(for: surah)
            }
        }
    }
}
