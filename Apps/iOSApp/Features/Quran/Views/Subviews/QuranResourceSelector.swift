//
//  QuranResourceSelector.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI

public struct QuranResourceSelector: View {
    let title: String
    let items: [(id: Int, title: String, subtitle: String?, tagline: String?)]
    @Binding var selection: Int
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    
    private var filteredItems: [(id: Int, title: String, subtitle: String?, tagline: String?)] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { 
                $0.title.localizedCaseInsensitiveContains(searchText) || 
                ($0.subtitle?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                ($0.tagline?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    public var body: some View {
        let colors = appEnv.theme.current
        
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(filteredItems, id: \.id) { item in
                            Button(action: {
                                selection = item.id
                                dismiss()
                            }) {
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.title)
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(colors.foreground)
                                            .lineLimit(1)
                                        
                                        HStack(spacing: 8) {
                                            if let subtitle = item.subtitle, !subtitle.isEmpty, subtitle != "Unknown" {
                                                Text(subtitle)
                                                    .lineLimit(1)
                                            }
                                            
                                            if let tagline = item.tagline, !tagline.isEmpty {
                                                if item.subtitle != nil && item.subtitle != "Unknown" {
                                                    Circle()
                                                        .fill(colors.foreground.opacity(0.1))
                                                        .frame(width: 3, height: 3)
                                                }
                                                Text(tagline.uppercased())
                                                    .fontWeight(.bold)
                                                    .foregroundColor(colors.primary)
                                            }
                                        }
                                        .font(.system(size: 11))
                                        .foregroundColor(colors.foreground.opacity(0.4))
                                    }
                                    
                                    Spacer()
                                    
                                    if selection == item.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(colors.primary)
                                            .font(.system(size: 20))
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 16)
                                .contentShape(Rectangle())
                            }
                            
                            if item.id != filteredItems.last?.id {
                                Divider()
                                    .padding(.leading, 24)
                                    .opacity(0.05)
                            }
                        }
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search \(title)")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(colors.foreground.opacity(0.8))
                    }
                }
            }
        }
    }
}
