//
//  AyahOptionsSheet.swift
//  Hira
//
//  Created by Ryuk on 08/04/26.
//

import SwiftUI

struct AyahOptionsSheet: View {
    let ayah: QuranAyah?
    @Bindable var viewModel: QuranViewModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        let colors = appEnv.theme.current
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // MARK: - Ayah Preview Header
                        if let ayah = ayah {
                            VStack(spacing: 20) {
                                // Arabic Typography Card
                                ZStack {
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .fill(colors.background)
                                        .hiraCleanCard(colors: colors, radius: 24)
                                    
                                    VStack(spacing: 16) {
                                        Text("﴾\(String(ayah.number).convertedToArabic())﴿ \(ayah.textArabic) ")
                                            .font(.custom("KFGQPC Uthman Taha Naskh", size: 32))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(colors.foreground)
                                            .padding(.horizontal, 8)
                                        
                                        Text(ayah.translation)
                                            .font(.system(size: 15))
                                            .foregroundColor(colors.foreground.opacity(0.6))
                                            .multilineTextAlignment(.center)
                                            .lineSpacing(4)
                                    }
                                    .padding(24)
                                    .environment(\.layoutDirection, .leftToRight)
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Primary Play Action
                                Button(action: {
                                    viewModel.activeAyah = ayah
                                    dismiss()
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "play.fill")
                                        Text("Play This Ayah")
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity)
                                    .background(colors.primary)
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                                    .shadow(color: colors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Divider().padding(.horizontal, 40).opacity(0.1)
                        
                        // MARK: - Secondary Options
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                optionItem(title: "Add to Playlist", icon: "music.note.list", color: .blue)
                                optionItem(title: "Bookmark", icon: "bookmark.fill", color: .orange)
                            }
                            
                            HStack(spacing: 12) {
                                optionItem(title: "Share Ayah", icon: "square.and.arrow.up", color: .purple)
                                optionItem(title: "Ask AI", icon: "sparkles", color: .pink)
                            }
                            
                            HStack(spacing: 12) {
                                optionItem(title: "Memorize", icon: "brain.head.profile", color: .green)
                                optionItem(title: "Settings", icon: "gearshape.fill", color: .gray)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle("Verse \(ayah?.number ?? 0)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(colors.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(colors.foreground.opacity(0.3))
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func optionItem(title: String, icon: String, color: Color) -> some View {
        let colors = appEnv.theme.current
        Button(action: { dismiss() }) {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(colors.background)
                        .hiraCleanCard(colors: colors, radius: 18)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(color)
                }
                .frame(height: 70)
                
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(colors.foreground)
                    .lineLimit(1)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
