//
//  QuranHeaderView.swift
//  Hira
//

import SwiftUI

public struct QuranHeaderView: View {
    @Binding var searchQuery: String
    @Environment(\.appEnvironment) private var appEnv
    
    public var body: some View {
        let colors = appEnv.theme.current
        HStack(spacing: 12) {
            // Integrated Search Bar matching HomeHeaderView
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(colors.primary.opacity(0.6))
                    .font(.body.bold())
                
                TextField(appEnv.language.localizedString("quran_search_placeholder_full"), text: $searchQuery)
                    .font(.subheadline)
                
                if !searchQuery.isEmpty {
                    Button(action: { searchQuery = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(colors.primary.opacity(0.4))
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(colors.foreground.opacity(0.04)))
            .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(colors.foreground.opacity(0.02), lineWidth: 1))
            
            // Audio Icon matching HomeHeader style
            Button(action: {}) {
                Image(systemName: "headphones")
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
