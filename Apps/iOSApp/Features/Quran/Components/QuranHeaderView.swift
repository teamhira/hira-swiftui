//
//  QuranHeaderView.swift
//  Hira
//

import SwiftUI

public struct QuranHeaderView: View {
    @Binding var searchQuery: String
    var onHistoryTap: () -> Void
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    
    public var body: some View {
        let colors = appEnv.theme.current
        HStack(spacing: 12) {
            // Morphing-style search button matching GlobalSearchView entry
            Button(action: {
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8)) {
                    router.navigate(to: .quranSearch)
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(colors.primary.opacity(0.6))
                        .font(.body.bold())
                    
                    Text(appEnv.language.localizedString("search_placeholder_short"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(colors.foreground.opacity(0.04)))
                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(colors.foreground.opacity(0.02), lineWidth: 1))
            }
            
            // History Button
            Button(action: onHistoryTap) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.title3)
                    .foregroundColor(colors.primary)
                    .padding(12)
                    .background(Circle().fill(colors.primary.opacity(0.1)))
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .background(colors.background)
    }
}
