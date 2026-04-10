//
//  TarteelSurahListView.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI

struct TarteelSurahListView: View {
    @Bindable var viewModel: TarteelViewModel
    @Environment(AppRouter.self) private var router
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "waveform.and.mic")
                        .font(.system(size: 48))
                        .foregroundColor(colors.primary)
                    
                    Text("Choose a Surah")
                        .font(.title2.bold())
                        .foregroundColor(colors.foreground)
                    
                    Text("Select a surah to start your AI-powered recitation practice.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 20)
                
                // Surah List
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.surahs) { surah in
                        Button(action: { router.navigate(to: .tarteelRecitation(surah)) }) {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(colors.primary.opacity(0.1))
                                        .frame(width: 44, height: 44)
                                    
                                    Text("\(surah.number)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(colors.primary)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(surah.name)
                                        .font(.headline)
                                        .foregroundColor(colors.foreground)
                                    
                                    Text("\(surah.versesCount) Verses")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text(surah.nameArabic)
                                    .font(.custom("Amiri-Bold", size: 20))
                                    .foregroundColor(colors.primary)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(colors.foreground.opacity(0.03))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(colors.foreground.opacity(0.05), lineWidth: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.top, 12)
                
                Spacer(minLength: 40)
            }
        }
    }
}
