//
//  HalalPlaceFilterCard.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

/// Search and filtering component for discovering Halal places.
struct HalalPlaceFilterCard: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    @Binding var searchText: String
    let colors: ThemeModel
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Information Area
            VStack(alignment: .leading, spacing: 4) {
                Text(appEnv.language.localizedString("halal_search_title"))
                    .font(.title3.bold())
                    .foregroundColor(colors.foreground)
                Text(appEnv.language.localizedString("halal_search_desc"))
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.6))
            }
            
            // MARK: - Interactive Input Field
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(colors.primary)
                    .padding(.leading, 4)
                
                TextField(appEnv.language.localizedString("halal_search_placeholder"), text: $searchText)
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
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(colors.primary.opacity(0.1), lineWidth: 1)
            )
        }
    }
}
