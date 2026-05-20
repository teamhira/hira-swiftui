//
//  HadithWidgetView.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct HadithWidgetView: View {
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    @StateObject private var viewModel = HadithWidgetViewModel()
    @State private var showDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "quote.opening")
                    .font(.title3)
                    .foregroundColor(colors.primary)
                Text(appEnv.language.localizedString("home_hadith_title"))
                    .font(.caption.bold())
                    .foregroundColor(colors.primary)
                    .kerning(1)
                Spacer()
            }
            
            if viewModel.isLoading {
                VStack(alignment: .leading, spacing: 10) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(colors.foreground.opacity(0.1))
                        .frame(height: 14)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(colors.foreground.opacity(0.1))
                        .frame(height: 14)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(colors.foreground.opacity(0.1))
                        .frame(height: 14)
                        .frame(width: 200)
                }
                .hiraShimmer()
            } else if let hadith = viewModel.hadith {
                VStack(alignment: .leading, spacing: 12) {
                    Text(hadith.english)
                        .font(.system(size: 16, weight: .medium, design: .serif))
                        .italic()
                        .foregroundColor(colors.foreground)
                        .lineSpacing(4)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Button {
                            showDetail = true
                        } label: {
                            Text(appEnv.language.localizedString("home_hadith_see_more"))
                                .font(.caption.bold())
                                .foregroundColor(colors.primary)
                        }
                        
                        Spacer()
                        
                        Text("— \(hadith.collectionName)")
                            .font(.caption.bold())
                            .foregroundColor(colors.foreground.opacity(0.4))
                            .lineLimit(1)
                    }
                }
            } else {
                Text(appEnv.language.localizedString("home_hadith_sample"))
                    .font(.system(size: 16, weight: .medium, design: .serif))
                    .italic()
                    .foregroundColor(colors.foreground.opacity(0.3))
            }
        }
        .padding(AppSpacing.lg)
        .hiraCleanCard(colors: colors)
        .padding(.horizontal, AppSpacing.lg)
        .contentShape(Rectangle())
        .onTapGesture {
            if viewModel.hadith != nil { showDetail = true }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(appEnv.language.localizedString("home_accessibility_hadith_card"))
        .sheet(isPresented: $showDetail) {
            if let hadith = viewModel.hadith {
                NavigationStack {
                    HadithDetailView(item: hadith)
                }
            }
        }
    }
}


#Preview {
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea()
        HadithWidgetView(colors: ThemeFactory.make(.green, isDark: false))
    }
}
