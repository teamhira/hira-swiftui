//
//  QuranLanguageSelector.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI

public struct QuranLanguageSelector: View {
    let title: String
    let items: [LanguageResponse]
    @Binding var selection: String
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    
    private var filteredItems: [LanguageResponse] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText) || 
                $0.isoCode.localizedCaseInsensitiveContains(searchText)
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
                        ForEach(filteredItems) { language in
                            Button(action: {
                                selection = language.isoCode
                                dismiss()
                            }) {
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(language.name)
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(colors.foreground)
                                        
                                        HStack(spacing: 8) {
                                            Text(language.isoCode.uppercased())
                                                .fontWeight(.bold)
                                                .foregroundColor(colors.primary)
                                            
                                            if let count = language.translationsCount {
                                                Circle()
                                                    .fill(colors.foreground.opacity(0.1))
                                                    .frame(width: 3, height: 3)
                                                
                                                HStack(spacing: 4) {
                                                    Image(systemName: "globe")
                                                    Text("\(count) Translations")
                                                }
                                            }
                                            
                                            if let dir = language.direction {
                                                Circle()
                                                    .fill(colors.foreground.opacity(0.1))
                                                    .frame(width: 3, height: 3)
                                                
                                                Text(dir.uppercased())
                                            }
                                        }
                                        .font(.system(size: 11))
                                        .foregroundColor(colors.foreground.opacity(0.4))
                                    }
                                    
                                    Spacer()
                                    
                                    if selection == language.isoCode {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(colors.primary)
                                            .font(.system(size: 20))
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 16)
                                .contentShape(Rectangle())
                            }
                            
                            if language.id != filteredItems.last?.id {
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
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Language")
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
