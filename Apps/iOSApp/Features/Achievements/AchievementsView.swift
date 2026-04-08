//
//  AchievementsView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct AchievementsView: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    @State private var viewModel = AchievementsViewModel()
    @State private var selectedAchievement: Achievement?
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    
                    // 1. Stats Header (Level and XP)
                    AchievementStatsHeader(
                        colors: colors,
                        level: viewModel.level,
                        levelName: viewModel.levelName,
                        currentXP: viewModel.currentXP,
                        maxXP: viewModel.maxXP
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    .id(viewModel.selectedCategory) // Force re-render when category changed for animation
                    .padding(.top, 16)
                    .padding(.horizontal, 24)
                    
                    // 2. Category Selector (Only if Journey exists)
                    if viewModel.isParticipatingInJourney {
                        HStack(spacing: 12) {
                            ForEach(viewModel.categories, id: \.self) { category in
                                Button(action: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        viewModel.selectedCategory = category
                                    }
                                }) {
                                    Text(appEnv.language.localizedString(category == "Global" ? "achievement_cat_global" : "achievement_cat_journey"))
                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                        .foregroundColor(viewModel.selectedCategory == category ? .white : colors.foreground.opacity(0.6))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 12)
                                        .background(
                                            ZStack {
                                                if viewModel.selectedCategory == category {
                                                    Capsule()
                                                        .fill(colors.primary)
                                                        .matchedGeometryEffect(id: "activeTab", in: namespace)
                                                } else {
                                                    Capsule()
                                                        .fill(colors.primary.opacity(0.05))
                                                }
                                            }
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // 3. Achievements List (Locked and Unlocked)
                    VStack(alignment: .leading, spacing: 24) {
                        Text(appEnv.language.localizedString("achievement_badge_title"))
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(colors.foreground)
                            .padding(.horizontal, 24)
                        
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filteredAchievements) { achievement in
                                Button(action: {
                                    selectedAchievement = achievement
                                }) {
                                    AchievementBadgeCard(
                                        achievement: achievement,
                                        colors: colors,
                                        appEnv: appEnv,
                                        history: viewModel.history(for: achievement.id)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal, 24)
                            }
                        }
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .navigationTitle(appEnv.language.localizedString("home_feature_achievements"))
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(action: { shareToInstagramStories() }) {
                        Label("Instagram Stories", systemImage: "camera.fill")
                    }
                    Button(action: { shareGeneral() }) {
                        Label("Share via...", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(colors.primary)
                }
            }
        }
        .sheet(item: $selectedAchievement) { achievement in
            AchievementDetailSheet(achievement: achievement, colors: colors, appEnv: appEnv)
                .presentationDetents([.fraction(0.85)])
                .presentationDragIndicator(.visible)
        }
        .alert(appEnv.language.localizedString("achievement_share_warning_title"), isPresented: $showingRiyaAlert) {
            Button(appEnv.language.localizedString("accessibility_button_cancel"), role: .cancel) { pendingShareAction = nil }
            Button(appEnv.language.localizedString("common_confirm_share")) {
                pendingShareAction?()
                pendingShareAction = nil
            }
        } message: {
            Text(appEnv.language.localizedString("achievement_share_warning_message"))
        }
    }
    
    @Namespace private var namespace
    
    // MARK: - Actions
    private func shareGeneral() {
        showRiyaWarning {
            let text = "I've reached Level \(viewModel.level) (\(viewModel.selectedCategory)) in Hira! 🌟\n\nCome and join the spiritual journey with Hira."
            let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = scene.windows.first?.rootViewController {
                rootVC.present(activityVC, animated: true)
            }
        }
    }
    
    private func shareToInstagramStories() {
        showRiyaWarning {
            guard let url = URL(string: "instagram-stories://share") else { return }
            
            if UIApplication.shared.canOpenURL(url) {
                let stickerImage = UIImage(systemName: "sparkles")!
                let imageData = stickerImage.pngData()!
                
                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor": "#ffffff",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#ffffff"
                ]
                
                let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)]
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                
                UIApplication.shared.open(url)
            } else {
                shareGeneral()
            }
        }
    }
    
    @State private var showingRiyaAlert = false
    @State private var pendingShareAction: (() -> Void)?
    
    private func showRiyaWarning(action: @escaping () -> Void) {
        pendingShareAction = action
        showingRiyaAlert = true
    }
}

#Preview {
    NavigationStack {
        AchievementsView()
            .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
    }
}
