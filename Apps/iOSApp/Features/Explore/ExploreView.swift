//
//  ExploreView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct ExploreView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    @State private var viewModel = ExploreViewModel()
    @State private var scrollOffset: CGFloat = 0
    
    private var colors: ThemeModel { appEnv.theme.current }
    private let headerThreshold: CGFloat = 80
    
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .top) {
            colors.background.ignoresSafeArea()
            
            // MARK: - Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    reelsSection
                    FeaturedBannerView()
                    eventsSection
                    discoverMoreSection
                    
                    Spacer(minLength: 120)
                }
                .padding(.top, 85)
                .background(
                    GeometryReader { proxy in
                        let minY = proxy.frame(in: .named("EXPLORE_SCROLL")).minY
                        Color.clear
                            .onAppear { scrollOffset = minY }
                            .onChange(of: minY) { _, new in
                                // Normalizing: initial minY is 0 because named space is on ZStack
                                scrollOffset = new
                            }
                    }
                )
            }
            
            // MARK: - Animated Fixed Header
            exploreHeader
        }
        .coordinateSpace(name: "EXPLORE_SCROLL")
    }
    
    private var exploreHeader: some View {
        // depth is positive as we scroll down
        let depth = -scrollOffset
        let progress = min(1.0, max(0.0, depth / 60))
        
        return VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Explore Title
                if progress < 0.95 {
                    Text(appEnv.language.localizedString("explore_title"))
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(colors.primary)
                        .scaleEffect(1.0 - (progress * 0.1), anchor: .leading)
                        .opacity(1.0 - (progress * 1.5))
                        .transition(.scale.combined(with: .opacity))
                }
                
                // Integrated Search Bar (Now a Navigation Button)
                Button(action: { router.navigate(to: .exploreSearch) }) {
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(colors.primary.opacity(0.6))
                            .font(.body.bold())
                        
                        Text(appEnv.language.localizedString("explore_search_placeholder"))
                            .font(.subheadline)
                            .foregroundColor(colors.foreground.opacity(0.4))
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 50)
                    .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(colors.foreground.opacity(0.04)))
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
            .padding(.top, 12)
            .background(colors.background)
            
            Divider()
                .opacity(progress)
        }
        .background(colors.background.ignoresSafeArea())
        .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.85), value: progress)
    }
    
    private var reelsSection: some View {
        VStack(spacing: 20) {
            SectionHeaderView(title: appEnv.language.localizedString("explore_reels_section"), icon: "play.rectangle.fill")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.reels) { reel in
                        ReelCard(reel: reel)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    private var eventsSection: some View {
        VStack(spacing: 20) {
            SectionHeaderView(title: appEnv.language.localizedString("explore_events_section"), icon: "calendar")
            
            VStack(spacing: 16) {
                ForEach(viewModel.events) { event in
                    EventRow(event: event)
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    private var discoverMoreSection: some View {
        VStack(spacing: 20) {
            SectionHeaderView(title: appEnv.language.localizedString("explore_discover_section"), icon: "safari.fill")
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(viewModel.categories) { category in
                    CategoryGridItem(category: category)
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - PreferenceKey for smooth scroll tracking
struct ScrollPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    NavigationStack {
        ExploreView()
            .environment(AppRouter())
            .environment(AppState())
    }
}
