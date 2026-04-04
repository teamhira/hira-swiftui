//
//  QiblaView.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI
import CoreLocation

public struct QiblaView: View {
    // MARK: - Dependencies
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    
    // MARK: - State
    @State private var viewModel = QiblaViewModel()
    @State private var isMapExpanded = false
    
    // MARK: - Computed Properties
    private var colors: ThemeModel { appEnv.theme.current }
    
    // MARK: - Initialization
    public init() {}
    
    // MARK: - Body
    public var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Map Header Area
                VStack(spacing: 0) {
                    QiblaMapView(userLocation: viewModel.userLocation)
                        .frame(height: isMapExpanded ? nil : 160)
                        .frame(maxHeight: isMapExpanded ? .infinity : 160)
                        .padding(.horizontal, 16)
                        .padding(.top, -20) // Pulled up significantly
                    
                    if !isMapExpanded {
                        QiblaStatsRow(
                            qiblaDirection: viewModel.qiblaDirection,
                            heading: viewModel.heading,
                            distanceToMecca: viewModel.distanceToMecca,
                            cardinalDirection: cardinalDirection(for: viewModel.qiblaDirection),
                            style: viewModel.selectedStyle
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                
                if !isMapExpanded {
                    // MARK: - Compass Content
                    Spacer(minLength: 5)
                    
                    // Compass Interaction
                    VStack(spacing: 12) {
                        QiblaCompass(
                            heading: viewModel.heading,
                            qiblaDirection: viewModel.qiblaDirection,
                            isFacing: viewModel.isFacingMecca,
                            style: viewModel.selectedStyle
                        )
                        
                        VStack(spacing: 4) {
                            Text(viewModel.isFacingMecca ? appEnv.language.localizedString("qibla_facing_mecca_success", defaultValue: "You're now facing Mecca") : appEnv.language.localizedString("qibla_facing_mecca_finding", defaultValue: "Almost there"))
                                .font(.headline.bold())
                                .foregroundColor(viewModel.isFacingMecca ? viewModel.selectedStyle.color : colors.foreground.opacity(0.3))
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(viewModel.isFacingMecca ? appEnv.language.localizedString("qibla_facing_mecca_success", defaultValue: "You're now facing Mecca") : appEnv.language.localizedString("qibla_facing_mecca_finding", defaultValue: "Almost there"))
                    }
                    .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 1.1)), 
                                         removal: .opacity.combined(with: .scale(scale: 0.8))))
                    
                    Spacer(minLength: 10)
                    
                    // MARK: - Theme Selection
                    QiblaThemeSelector(
                        selectedStyle: $viewModel.selectedStyle,
                        onSelect: { triggerHaptic(.soft) }
                    )
                } else {
                    // Padding at the bottom for expanded map to breathe
                    Spacer().frame(height: 20)
                }
            }
            
            // Location Permission Overlay
            if (viewModel.authorizationStatus == .denied || 
               viewModel.authorizationStatus == .restricted ||
               (viewModel.authorizationStatus == .notDetermined && viewModel.userLocation == nil)) {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                locationNotice
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(), value: viewModel.authorizationStatus)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // MARK: - Navigation Bar Items
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { router.pop() }) {
                    Image(systemName: "chevron.left")
                        .font(.body.bold())
                        .foregroundColor(colors.primary)
                        .frame(width: 44, height: 44)
                        .background(colors.foreground.opacity(0.03))
                        .clipShape(Circle())
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(appEnv.language.localizedString("home_feature_qibla"))
                    .font(.headline.bold())
                    .foregroundColor(colors.foreground)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { 
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        isMapExpanded.toggle()
                    }
                    triggerHaptic(.light)
                }) {
                    Image(systemName: isMapExpanded ? "compass.drawing" : "location.viewfinder")
                        .font(.title3)
                        .foregroundColor(colors.primary)
                        .frame(width: 44, height: 44)
                        .background(colors.foreground.opacity(0.03))
                        .clipShape(Circle())
                }
            }
        }
    }
    
    // MARK: - Subviews
    private var locationNotice: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "location.viewfinder")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(colors.primary)
            }
            
            VStack(spacing: 8) {
                Text(appEnv.language.localizedString("location_permission_title", defaultValue: "Location Access Required"))
                    .font(.title3.bold())
                    .foregroundColor(colors.foreground)
                
                Text(appEnv.language.localizedString("location_permission_desc", defaultValue: "We need your location to provide accurate prayer times, Qibla direction, and other localized features."))
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(colors.foreground.opacity(0.6))
                    .padding(.horizontal, 8)
            }
            
            Button(action: {
                if viewModel.authorizationStatus == .denied || viewModel.authorizationStatus == .restricted {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                } else {
                    viewModel.requestPermissions()
                }
                triggerHaptic(.medium)
            }) {
                Text(viewModel.authorizationStatus == .denied ? appEnv.language.localizedString("qibla_permission_settings_button", defaultValue: "Open Settings") : appEnv.language.localizedString("qibla_permission_allow_button", defaultValue: "Allow Access"))
                    .font(.body.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(colors.primary)
                    .clipShape(Capsule())
                    .shadow(color: colors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.top, 8)
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(colors.background)
        )
        .padding(24)
    }
    
    // MARK: - Helpers
    private func cardinalDirection(for bearing: Double) -> String {
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"]
        let index = Int((bearing + 22.5).truncatingRemainder(dividingBy: 360) / 45)
        return index < directions.count ? directions[index] : "N"
    }
    
    // MARK: - Actions
    private func triggerHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}

#Preview {
    NavigationStack {
        QiblaView()
            .environment(AppRouter())
            .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
    }
}
