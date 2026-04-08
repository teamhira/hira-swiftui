//
//  SuggestionDetailView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct SuggestionDetailView: View {
    let suggestion: Suggestion
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    
    private var colors: ThemeModel { appEnv.theme.current }
    @State private var currentModuleIndex = 0
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with Progress
                headerView
                
                // LMS-style Module View
                TabView(selection: $currentModuleIndex) {
                    ForEach(0..<suggestion.modules.count, id: \.self) { index in
                        moduleContentView(suggestion.modules[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Bottom Navigation
                bottomActionBar
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Components
    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: { router.pop() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(colors.foreground)
                        .frame(width: 44, height: 44)
                        .background(colors.foreground.opacity(0.05))
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(suggestion.title)
                        .font(.subheadline.bold())
                    Text("Langkah \(currentModuleIndex + 1) dari \(suggestion.modules.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.leading, 8)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(colors.primary.opacity(0.1), lineWidth: 4)
                        .frame(width: 44, height: 44)
                    Circle()
                        .trim(from: 0, to: Double(currentModuleIndex + 1) / Double(suggestion.modules.count))
                        .stroke(colors.primary, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 44, height: 44)
                        .rotationEffect(.degrees(-90))
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
        }
        .padding(.bottom, 16)
        .background(colors.background)
    }
    
    private func moduleContentView(_ module: SuggestionModule) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                // Module Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(module.title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(colors.foreground)
                    
                    if let desc = module.description {
                        Text(desc)
                            .font(.body)
                            .foregroundColor(colors.foreground.opacity(0.6))
                            .lineSpacing(6)
                    }
                }
                .padding(.bottom, 16)
                
                // Content Blocks
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(module.content, id: \.self) { block in
                        ContentBlockRow(block: block, colors: colors)
                    }
                }
                
                Spacer(minLength: 50)
            }
            .padding(24)
        }
    }
    
    private var bottomActionBar: some View {
        HStack(spacing: 16) {
            if currentModuleIndex > 0 {
                Button(action: { withAnimation { currentModuleIndex -= 1 } }) {
                    Text("Kembali")
                        .font(.headline.bold())
                        .foregroundColor(colors.foreground)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(colors.foreground.opacity(0.05))
                        .cornerRadius(16)
                }
            }
            
            Button(action: handleNext) {
                Text(currentModuleIndex == suggestion.modules.count - 1 ? "Selesai" : "Lanjut")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(colors.primary)
                    .cornerRadius(16)
            }
        }
        .padding(24)
        .background(colors.background)
    }
    
    private func handleNext() {
        if currentModuleIndex < suggestion.modules.count - 1 {
            withAnimation { currentModuleIndex += 1 }
        } else {
            router.pop()
        }
    }
}
