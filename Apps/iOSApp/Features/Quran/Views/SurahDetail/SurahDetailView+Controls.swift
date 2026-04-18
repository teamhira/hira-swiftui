//
//  SurahDetailView+Controls.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI

extension SurahDetailView {
    @ViewBuilder
    func bottomControls(colors: ThemeModel) -> some View {
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
    func autoScrollIndicator(colors: ThemeModel) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.green)
                .frame(width: 8, height: 8)
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
    func miniAudioPlayer(colors: ThemeModel) -> some View {
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
}
