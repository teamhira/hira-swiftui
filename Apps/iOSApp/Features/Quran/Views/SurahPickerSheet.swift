//
//  SurahPickerSheet.swift
//  Hira
//
//  Created by Ryuk on 08/04/26.
//

import SwiftUI

struct SurahPickerSheet: View {
    @Binding var currentSurah: Surah
    @Binding var currentPage: PageItem
    @Environment(QuranViewModel.self) private var viewModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedSurahForAyah: Surah?
    
    var filteredSurahs: [Surah] {
        if searchText.isEmpty { return viewModel.surahs }
        return viewModel.surahs.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        let colors = appEnv.theme.current
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredSurahs) { surah in
                            Button(action: { selectedSurahForAyah = surah }) {
                                HStack(spacing: 16) {
                                    Text("\(surah.number)")
                                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                                        .foregroundColor(colors.primary)
                                        .frame(width: 40, height: 40)
                                        .background(Circle().fill(colors.primary.opacity(0.1)))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(surah.name)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(colors.foreground)
                                        Text("\(surah.versesCount) Verses • \(surah.revelationPlace)")
                                            .font(.system(size: 12))
                                            .foregroundColor(colors.foreground.opacity(0.5))
                                    }
                                    
                                    Spacer()
                                    
                                    Text(surah.nameArabic)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(colors.primary)
                                }
                                .padding(16)
                                .background(RoundedRectangle(cornerRadius: 16).fill(colors.foreground.opacity(0.04)))
                            }
                        }
                    }
                    .padding(20)
                }
                .background(colors.background)
            }
            .navigationTitle("Select Surah")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Surah")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(colors.primary)
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationDestination(item: $selectedSurahForAyah) { surah in
                AyahPickerView(surah: surah) { selectedAyah in
                    withAnimation(.spring()) {
                        viewModel.activeAyah = selectedAyah
                        currentSurah = surah
                        
                        // Handle Mushaf mode page jump
                        if let page = selectedAyah.pageNumber {
                            currentPage = PageItem(number: page)
                        }
                    }
                    dismiss()
                }
            }
        }
        .background(colors.background)
    }
}

struct AyahPickerView: View {
    let surah: Surah
    @Environment(QuranViewModel.self) private var viewModel
    let onSelect: (QuranAyah) -> Void
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        let colors = appEnv.theme.current
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Modern Header
                    VStack(spacing: 8) {
                        Text(surah.name)
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundColor(colors.primary)
                        
                        Text("Choose a verse to jump to")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(colors.foreground.opacity(0.4))
                        
                        Rectangle()
                            .fill(colors.primary.opacity(0.2))
                            .frame(width: 40, height: 2)
                            .padding(.top, 4)
                    }
                    .padding(.top, 24)
                    
                    // Grid loading state
                    if viewModel.isAyahsLoading(for: surah) && viewModel.ayahCache[surah.number] == nil {
                        VStack(spacing: 12) {
                            ProgressView()
                            Text("Loading verses...")
                                .font(.system(size: 13))
                                .foregroundColor(colors.primary.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    } else {
                        // Premium Grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5), spacing: 12) {
                            ForEach(viewModel.ayahs(for: surah)) { ayah in
                                Button(action: {
                                    onSelect(ayah)
                                }) {
                                    Text("\(ayah.number)")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundColor(viewModel.activeAyah?.id == ayah.id ? colors.background : colors.foreground)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 54)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(viewModel.activeAyah?.id == ayah.id ? colors.primary : colors.primary.opacity(0.06))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(colors.primary.opacity(0.1), lineWidth: 1)
                                        )
                                }
                                .disabled(ayah.isPlaceholder)
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
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear {
            if viewModel.ayahCache[surah.number] == nil {
                viewModel.fetchAyahs(for: surah)
            }
        }
    }
}
