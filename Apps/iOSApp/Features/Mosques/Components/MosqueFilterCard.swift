//
//  MosqueFilterCard.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct MosqueFilterCard: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    @Binding var searchText: String
    let colors: ThemeModel
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Title Section
            VStack(alignment: .leading, spacing: 4) {
                Text(appEnv.language.localizedString("mosque_search_title"))
                    .font(.title3.bold())
                    .foregroundColor(colors.foreground)
                Text(appEnv.language.localizedString("mosque_search_desc"))
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.6))
            }
            
            // MARK: - Search Field
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(colors.primary)
                    .padding(.leading, 4)
                
                TextField(appEnv.language.localizedString("mosque_search_placeholder"), text: $searchText)
                    .font(.body)
                    .accentColor(colors.primary)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(colors.foreground.opacity(0.3))
                    }
                    .padding(.trailing, 4)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(colors.foreground.opacity(0.04))
            .cornerRadius(24) // Match design system roundedness
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(colors.primary.opacity(0.1), lineWidth: 1)
            )
        }
    }
}


