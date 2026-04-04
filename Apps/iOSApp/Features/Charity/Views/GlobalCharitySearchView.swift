//
//  GlobalCharitySearchView.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct GlobalCharitySearchView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    @State private var searchText = ""
    @State private var isSearching = false
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack(alignment: .top) {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    // MARK: - Quick Search Chips
                    quickSearchSection
                    
                    // MARK: - Urgent Causes
                    urgentCausesSection
                    
                    // MARK: - Top Community Causes
                    communityCausesSection
                    
                    Spacer(minLength: 50)
                }
                .padding(.top, 110)
            }
            
            // MARK: - Dynamic Morphing Header
            searchHeader
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Subviews
    private var quickSearchSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(colors.primary)
                Text(appEnv.language.localizedString("charity_quick_search_title"))
                    .font(.headline.bold())
            }
            .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    CharityQuickSearchChip(title: appEnv.language.localizedString("charity_category_zakat"), icon: "percent")
                    CharityQuickSearchChip(title: appEnv.language.localizedString("charity_category_sedekah"), icon: "heart.fill")
                    CharityQuickSearchChip(title: appEnv.language.localizedString("charity_category_infaq"), icon: "gift.fill")
                    CharityQuickSearchChip(title: appEnv.language.localizedString("charity_category_wakaf"), icon: "building.2.fill")
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    private var urgentCausesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                Text(appEnv.language.localizedString("charity_urgent_causes_title"))
                    .font(.headline.bold())
            }
            .padding(.horizontal, 24)
            
            VStack(spacing: 16) {
                CharityUrgentCauseRow(
                    title: "Bantuan Darurat Gaza",
                    subtitle: "3 hari lagi",
                    current: 45000,
                    target: 80000,
                    image: "building.columns.fill",
                    color: .red
                )
                
                CharityUrgentCauseRow(
                    title: "Bantuan Banjir Indonesia",
                    subtitle: "7 hari lagi",
                    current: 32000,
                    target: 50000,
                    image: "water.waves",
                    color: .blue
                )
            }
            .padding(.horizontal, 24)
        }
    }
    
    private var communityCausesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(colors.primary)
                Text(appEnv.language.localizedString("charity_top_community_causes_title"))
                    .font(.headline.bold())
            }
            .padding(.horizontal, 24)
            
            VStack(spacing: 16) {
                CharityCommunityCauseRow(title: "Bangun Masjid di Daerah Terpencil", progress: 0.75, raised: 75000, donors: 234)
                CharityCommunityCauseRow(title: "Proyek Sumur Air Bersih", progress: 0.70, raised: 28000, donors: 156)
            }
            .padding(.horizontal, 24)
        }
    }
    
    private var searchHeader: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                // Back Button (Native Look + Glass)
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
                
                // Morphing Search Bar
                    if !isSearching {
                        Text(appEnv.language.localizedString("tab_charity"))
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
                            TextField(appEnv.language.localizedString("charity_search_placeholder"), text: $searchText)
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
            .padding(.horizontal, 24)
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
}
