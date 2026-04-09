//
//  GlobalQuranSearchView.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI

struct GlobalQuranSearchView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    @State private var searchText = ""
    @State private var isSearching = false
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack(alignment: .top) {
            colors.background.ignoresSafeArea()
            
            // MARK: - Content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    
                    // MARK: - Discover Quran
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: appEnv.language.localizedString("quran_search_discover_title"), icon: "star")
                            .padding(.horizontal, 24)
                        
                        FlowLayout(spacing: 8) {
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_discover_signs"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_discover_rewards"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_discover_prophets"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_discover_guidance"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_discover_afterlife"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_discover_moral"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_discover_worship"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_discover_charity"))
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // MARK: - Prophet Stories
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: appEnv.language.localizedString("quran_search_prophets_title"), icon: "book")
                            .padding(.horizontal, 24)
                        
                        FlowLayout(spacing: 8) {
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_prophet_lut"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_prophet_zakariya"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_prophet_muhammad"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_prophet_isa"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_prophet_daud"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_prophet_salih"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_prophet_idris"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_prophet_ayyub"))
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // MARK: - How are you feeling?
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: appEnv.language.localizedString("quran_search_feeling_title"), icon: "heart")
                            .padding(.horizontal, 24)
                        
                        FlowLayout(spacing: 8) {
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_feeling_grateful"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_feeling_anxious"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_feeling_thankful"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_feeling_calm"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_feeling_envious"))
                            SuggestionChip(title: appEnv.language.localizedString("quran_search_feeling_peaceful"))
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.top, 110) // Consistent spacing for custom header
            }
            
            // MARK: - Custom Glass Header (Toolbar)
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    // Back Button
                    Button(action: { router.pop() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(colors.foreground)
                            .frame(width: 44, height: 44)
                            .background(
                                VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(colors.foreground.opacity(0.05), lineWidth: 0.5))
                            )
                    }
                    
                    // Morphing Search Bar matching GlobalSearchView
                    HStack(spacing: 0) {
                        if !isSearching {
                            Text(appEnv.language.localizedString("search_placeholder_short"))
                                .font(.headline.bold())
                                .foregroundColor(colors.foreground)
                                .transition(.opacity.combined(with: .move(edge: .leading)))
                            Spacer()
                        }
                        
                        HStack(spacing: isSearching ? 12 : 0) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(isSearching ? .secondary : colors.primary)
                            
                            if isSearching {
                                TextField(appEnv.language.localizedString("search_placeholder_long"), text: $searchText)
                                    .font(.subheadline)
                                    .submitLabel(.search)
                                    .transition(.opacity)
                                
                                if !searchText.isEmpty {
                                    Button(action: { searchText = "" }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.secondary.opacity(0.6))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, isSearching ? 16 : 0)
                        .frame(height: 48)
                        .frame(maxWidth: isSearching ? .infinity : 48)
                        .background(
                            VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                                .background(isSearching ? Color.clear : colors.primary.opacity(0.05))
                                .cornerRadius(24)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(colors.foreground.opacity(0.1), lineWidth: 0.5)
                                .opacity(isSearching ? 1 : 0)
                        )
                        .onTapGesture {
                            if !isSearching {
                                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8)) {
                                    isSearching = true
                                }
                            }
                        }
                        
                        if isSearching {
                            Button(action: {
                                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8)) {
                                    isSearching = false
                                    searchText = ""
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(colors.foreground)
                                    .frame(width: 32, height: 32)
                                    .background(VisualEffectBlur(blurStyle: .systemUltraThinMaterial).clipShape(Circle()))
                                    .overlay(Circle().stroke(colors.foreground.opacity(0.1), lineWidth: 0.5))
                            }
                            .padding(.leading, 12)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                .padding(.top, 10)
                .background(
                    VisualEffectBlur(blurStyle: .systemChromeMaterial)
                        .ignoresSafeArea(edges: .top)
                        .overlay(
                            VStack {
                                Spacer()
                                Divider().opacity(0.5)
                            }
                        )
                )
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Supporting Views
private struct SectionHeader: View {
    let title: String
    let icon: String
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(colors.primary)
            Text(title)
                .font(.title3.bold())
                .foregroundColor(colors.foreground)
        }
    }
}

private struct SuggestionChip: View {
    let title: String
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .bold))
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(colors.foreground.opacity(0.04))
                    .overlay(
                        Capsule()
                            .stroke(colors.foreground.opacity(0.08), lineWidth: 1)
                    )
            )
            .foregroundColor(colors.foreground)
    }
}

#Preview {
    NavigationStack {
        GlobalQuranSearchView()
            .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
    }
}
