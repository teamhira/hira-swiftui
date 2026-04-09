//
//  QuranAudioView.swift
//  Hira
//
//  Created by Ryuk on 08/04/26.
//

import SwiftUI

public struct QuranAudioView: View {
    @Bindable var viewModel: QuranViewModel
    @Binding var currentSurah: Surah
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    @State private var playbackSpeed: Double = 1.0
    @State private var repeatMode: String = "never"
    @State private var currentTime: Double = 45 // Dummy
    @State private var totalTime: Double = 180 // Dummy
    @State private var showingSettingsLocal = false
    
    private let speeds = [1.0, 1.5, 2.0, 0.5]
    private let repeatOptions = ["never", "1 time", "2 times", "3 times", "indefinitely"]
    
    public var body: some View {
        let colors = appEnv.theme.current
        NavigationStack {
            ZStack(alignment: .bottom) {
                colors.background.ignoresSafeArea()
                
                // MARK: - Main Content (Interactive Ayah List)
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 32) {
                            Spacer(minLength: 100)
                            
                            ForEach(viewModel.ayahs(for: currentSurah)) { ayah in
                                AyahAudioRow(ayah: ayah, isActive: viewModel.activeAyah?.id == ayah.id)
                                    .id(ayah.id)
                                    .onTapGesture {
                                        withAnimation { viewModel.activeAyah = ayah }
                                    }
                            }
                            
                            Spacer(minLength: 250)
                        }
                    }
                    .onChange(of: viewModel.activeAyah) { _, newValue in
                        if let id = newValue?.id {
                            withAnimation { proxy.scrollTo(id, anchor: .center) }
                        }
                    }
                }
                
                // MARK: - Advanced Floating Player HUD
                VStack(spacing: 20) {
                    // Progress Bar
                    VStack(spacing: 8) {
                        Slider(value: $currentTime, in: 0...totalTime)
                            .tint(colors.primary)
                        
                        HStack {
                            Text(formatTime(currentTime))
                            Spacer()
                            Text(formatTime(totalTime))
                        }
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(colors.foreground.opacity(0.5))
                    }
                    .padding(.horizontal, 24)
                    
                    // Controls HUD
                    HStack(spacing: 0) {
                        // Speed Selector
                        Menu {
                            ForEach(speeds, id: \.self) { speed in
                                Button("\(speed == 1.0 ? "Normal" : String(format: "%.1fx", speed))") {
                                    playbackSpeed = speed
                                }
                            }
                        } label: {
                            Text(String(format: "%.1fx", playbackSpeed))
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .frame(width: 44, height: 44)
                                .background(colors.primary.opacity(0.1))
                                .foregroundColor(colors.primary)
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        // Main Controls
                        HStack(spacing: 32) {
                            Button(action: { prevAyah() }) {
                                Image(systemName: "backward.fill")
                                    .font(.title2)
                            }
                            
                            Button(action: {}) {
                                ZStack {
                                    Circle()
                                        .fill(colors.primary)
                                        .frame(width: 56, height: 56)
                                    Image(systemName: "play.fill")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                }
                            }
                            
                            Button(action: { nextAyah() }) {
                                Image(systemName: "forward.fill")
                                    .font(.title2)
                            }
                        }
                        .foregroundColor(colors.foreground)
                        
                        Spacer()
                        
                        // Repeat Selector
                        Menu {
                            Picker("Repeat", selection: $repeatMode) {
                                ForEach(repeatOptions, id: \.self) { option in
                                    Text(option.capitalized).tag(option)
                                }
                            }
                        } label: {
                            Image(systemName: repeatMode == "never" ? "repeat" : "repeat.1")
                                .font(.system(size: 16, weight: .bold))
                                .frame(width: 44, height: 44)
                                .background(colors.primary.opacity(0.1))
                                .foregroundColor(colors.primary)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(colors.primary.opacity(0.1), lineWidth: 1))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                }
                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(colors.foreground.opacity(0.5))
                }
                
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 0) {
                        Text(currentSurah.name)
                            .font(.headline)
                        Text("Recitation Mode")
                            .font(.system(size: 10))
                            .foregroundColor(colors.primary)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingSettingsLocal = true }) {
                        Image(systemName: "gearshape")
                    }
                    .foregroundColor(colors.foreground)
                }
            }
        }
        .sheet(isPresented: $showingSettingsLocal) {
            QuranSettingsSheet(viewModel: viewModel)
        }
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    private func nextAyah() {
        let ayahs = viewModel.ayahs(for: currentSurah)
        guard let current = viewModel.activeAyah,
              let index = ayahs.firstIndex(where: { $0.id == current.id }) else { return }
        
        if index < ayahs.count - 1 {
            viewModel.activeAyah = ayahs[index + 1]
        }
    }
    
    private func prevAyah() {
        let ayahs = viewModel.ayahs(for: currentSurah)
        guard let current = viewModel.activeAyah,
              let index = ayahs.firstIndex(where: { $0.id == current.id }) else { return }
        
        if index > 0 {
            viewModel.activeAyah = ayahs[index - 1]
        }
    }
}

struct AyahAudioRow: View {
    let ayah: QuranAyah
    let isActive: Bool
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        let colors = appEnv.theme.current
        VStack(spacing: 12) {
            Text(ayah.textArabic)
                .font(.custom("KFGQPC Uthman Taha Naskh", size: 28))
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 24)
                .foregroundColor(isActive ? colors.primary : colors.foreground)
                .scaleEffect(isActive ? 1.02 : 1.0)
            
            if isActive {
                Text(ayah.translation)
                    .font(.subheadline)
                    .foregroundColor(colors.foreground.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(isActive ? colors.primary.opacity(0.05) : Color.clear)
        .animation(.spring(), value: isActive)
    }
}
