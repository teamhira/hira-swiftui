//
//  CharityView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct CharityView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    @State private var viewModel = CharityViewModel()
    @State private var scrollOffset: CGFloat = 0
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .top) {
            colors.background.ignoresSafeArea()
            
            // MARK: - Content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    Spacer(minLength: 50) // Reduced from 80 to bring content closer to header
                    
                    // MARK: - Purpose Categories
                    purposeCategories
                    
                    // MARK: - Simplified Zakat Card
                    zakatCalculatorCard
                    
                    // MARK: - Community Causes
                    communityCauses
                    
                    Spacer(minLength: 50)
                }
                .background(
                    GeometryReader { proxy in
                        let minY = proxy.frame(in: .named("CHARITY_SCROLL")).minY
                        Color.clear
                            .onAppear { scrollOffset = minY }
                            .onChange(of: minY) { _, new in
                                scrollOffset = new
                            }
                    }
                )
            }
            .coordinateSpace(name: "CHARITY_SCROLL")
            
            // MARK: - Custom Dynamic Header
            charityHeader
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Subviews
    private var purposeCategories: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundColor(colors.primary)
                    .font(.title3)
                Text(appEnv.language.localizedString("charity_berikan_tujuan_title"))
                    .font(.headline.bold())
                Spacer()
                Button(appEnv.language.localizedString("charity_see_all")) { router.navigate(to: .charitySearch) }
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                CharityCategoryIcon(title: appEnv.language.localizedString("charity_category_sedekah"), icon: "heart.fill")
                CharityCategoryIcon(title: appEnv.language.localizedString("charity_category_orphan"), icon: "heart.circle.fill")
                CharityCategoryIcon(title: appEnv.language.localizedString("charity_category_infaq"), icon: "gift.fill")
                CharityCategoryIcon(title: appEnv.language.localizedString("charity_category_wakaf"), icon: "building.2.fill")
                CharityCategoryIcon(title: appEnv.language.localizedString("charity_category_fidyah"), icon: "hand.raised.fill")
                CharityCategoryIcon(title: appEnv.language.localizedString("charity_category_kaffarah"), icon: "person.2.fill")
            }
        }
        .padding(.horizontal, 24)
    }
    
    private var zakatCalculatorCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 50, height: 50)
                Image(systemName: "percent")
                    .foregroundColor(colors.primary)
                    .font(.title3.bold())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(appEnv.language.localizedString("charity_kalkulator_zakat_title"))
                    .font(.subheadline.bold())
                Text(appEnv.language.localizedString("charity_kalkulator_zakat_desc"))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundColor(.secondary)
        }
        .padding(16)
        .hiraCleanCard(colors: colors)
        .padding(.horizontal, 24)
    }
    
    private var communityCauses: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "heart.text.square.fill")
                    .foregroundColor(colors.primary)
                    .font(.title3)
                Text(appEnv.language.localizedString("charity_community_causes_title"))
                    .font(.headline.bold())
                Spacer()
                Button(appEnv.language.localizedString("charity_see_all")) { router.navigate(to: .charitySearch) }
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
            }
            
            CharityCauseCard(
                title: "Bangun Sekolah Islam di Daerah Terpencil",
                description: "Bantu kami mambangun sekolah Islam baru untuk memberikan pendidikan berkualitas.",
                image: "building.columns.fill",
                raised: 75000,
                target: 100000,
                progress: 0.75,
                donors: 234,
                days: 15
            )
        }
        .padding(.horizontal, 24)
    }
    
    private var charityHeader: some View {
        let depth = -scrollOffset
        let progress = min(1.0, max(0.0, depth / 60))
        
        return VStack(spacing: 0) {
            HStack(spacing: 16) {
                // Title Area
                if progress < 0.9 {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(appEnv.language.localizedString("charity_title"))
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(colors.foreground)
                        Text(appEnv.language.localizedString("charity_subtitle"))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .opacity(1.0 - progress * 1.5)
                    .transition(.opacity.combined(with: .move(edge: .leading)))
                }
                
                if progress < 0.9 {
                    Spacer()
                }
                
                // Search Button (Expansion logic)
                Button(action: { router.navigate(to: .charitySearch) }) {
                    HStack(spacing: progress > 0.5 ? 12 : 0) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(progress > 0.5 ? colors.primary : colors.foreground)
                            .frame(width: progress > 0.5 ? nil : 50, height: 50)
                        
                        if progress > 0.5 {
                            Text(appEnv.language.localizedString("charity_search_placeholder"))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .transition(.opacity)
                        }
                    }
                    .padding(.leading, progress > 0.5 ? 16 : 0)
                    .frame(height: 50)
                    .frame(maxWidth: progress > 0.5 ? .infinity : 50, alignment: progress > 0.5 ? .leading : .center)
                    .background(
                        VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(colors.foreground.opacity(0.1), lineWidth: 0.5)
                            )
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            .padding(.top, 6)
            .background(
                VisualEffectBlur(blurStyle: .systemChromeMaterial)
                    .ignoresSafeArea()
                    .overlay(
                        VStack {
                            Spacer()
                            Divider().opacity(progress)
                        }
                    )
            )
        }
        .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.8), value: progress)
    }
}

// MARK: - Scroll Offset Tracker
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
