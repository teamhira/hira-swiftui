//
//  HajjUmrahView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct HajjUmrahView: View {
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = HajjUmrahViewModel()
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        FeatureView(titleKey: "home_feature_hajjumrah", icon: "person.2.fill") {
            VStack(spacing: 32) {
                // Guide Card
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(appEnv.language.localizedString("hajjumrah_guide_title"))
                            .font(.headline.bold())
                            .foregroundColor(colors.foreground)
                        Text(appEnv.language.localizedString("hajjumrah_guide_desc"))
                            .font(.caption)
                            .foregroundColor(colors.foreground.opacity(0.6))
                        
                        Button(action: {}) {
                            Text(appEnv.language.localizedString("hajjumrah_start_btn"))
                                .font(.caption.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 8)
                                .background(colors.primary)
                                .cornerRadius(20)
                        }
                    }
                    Spacer()
                    Image(systemName: "book.fill")
                        .font(.largeTitle)
                        .foregroundColor(colors.primary)
                }
                .padding(24)
                .background(colors.background)
                .hiraCleanCard(colors: colors, radius: 24)
                .accessibilityElement(children: .contain)
                
                // Sections Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.guides, id: \.self) { item in
                        VStack(spacing: 12) {
                            Circle()
                                .fill(colors.primary.opacity(0.1))
                                .frame(width: 44, height: 44)
                                .overlay {
                                    Image(systemName: "bookmark.fill")
                                        .foregroundColor(colors.primary)
                                }
                            Text(item)
                                .font(.subheadline.bold())
                                .foregroundColor(colors.foreground)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(colors.background)
                        .hiraCleanCard(colors: colors, radius: 20)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(item)
                        .accessibilityAddTraits(.isButton)
                    }
                }
                
                // Doa Area Placeholder
                VStack(alignment: .leading, spacing: 20) {
                    Text(appEnv.language.localizedString("hajjumrah_dua_title"))
                        .font(.headline.bold())
                        .foregroundColor(colors.foreground)
                    
                    VStack(spacing: 16) {
                        EmptyStatePlaceholder(colors: colors, text: appEnv.language.localizedString("hajjumrah_dua_placeholder"))
                    }
                }
            }
            .eraseToAnyView()
        }
    }
}

private struct EmptyStatePlaceholder: View {
    let colors: ThemeModel
    let text: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text.fill")
                .font(.largeTitle)
                .foregroundColor(colors.foreground.opacity(0.1))
            Text(text)
                .font(.caption)
                .foregroundColor(colors.foreground.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}
