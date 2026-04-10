//
//  TarteelRecitationView.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI

struct TarteelRecitationView: View {
    @Bindable var viewModel: TarteelViewModel
    @Environment(AppRouter.self) private var router
    let surah: Surah
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    private var colors: ThemeModel { appEnv.theme.current }
    @State private var selectedAyah: QuranAyah?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Info
                surahHeader
                
                // Ayah List
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 32) {
                            ForEach(viewModel.ayahs(for: surah)) { ayah in
                                TarteelAyahRow(
                                    ayah: ayah,
                                    result: viewModel.results[ayah.id],
                                    isSelected: selectedAyah?.id == ayah.id
                                )
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        selectedAyah = ayah
                                        proxy.scrollTo(ayah.id, anchor: .center)
                                    }
                                }
                                .id(ayah.id)
                            }
                            
                            Spacer(minLength: 150)
                        }
                        .padding(.top, 24)
                    }
                    .onChange(of: selectedAyah) { oldValue, newValue in
                        if let newValue = newValue {
                            withAnimation {
                                proxy.scrollTo(newValue.id, anchor: .center)
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
            
            // Floating Record Button
            VStack {
                Spacer()
                TarteelRecordButton(isRecording: $viewModel.isRecording) {
                    if let ayah = selectedAyah {
                        if viewModel.isRecording {
                            viewModel.stopRecording(for: ayah)
                            
                            // Auto-advance to next ayah
                            let ayahs = viewModel.ayahs(for: surah)
                            if let index = ayahs.firstIndex(where: { $0.id == ayah.id }),
                               index + 1 < ayahs.count {
                                withAnimation(.spring()) {
                                    let nextAyah = ayahs[index + 1]
                                    selectedAyah = nextAyah
                                    // The ScrollViewReader will catch up because of the id(ayah.id) and onChange
                                }
                            }
                        } else {
                            viewModel.startRecording()
                        }
                    }
                }
                .padding(.bottom, 30)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
// ... (skipping to toolbar)
// ...
        .toolbar {
// ... (skipping to onAppear)
// ...
        }
        .onAppear {
            if selectedAyah == nil {
                selectedAyah = viewModel.ayahs(for: surah).first
            }
        }
        .onDisappear {
            viewModel.saveToHistory()
        }
    }
    
    private var surahHeader: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recitation Progress")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 12) {
                        ProgressView(value: viewModel.surahProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: colors.primary))
                            .frame(width: 100)
                        
                        Text("\(Int(viewModel.surahProgress * 100))%")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(colors.primary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(surah.nameArabic)
                        .font(.custom("Amiri-Bold", size: 24))
                        .foregroundColor(colors.primary)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(colors.background)
            
            Divider()
                .background(colors.foreground.opacity(0.1))
        }
    }
}
