//
//  HalalView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI
import MapKit

/// Main entry point for the Halal Finder feature, supporting Map/List exploration and Food scanning.
struct HalalView: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = HalalViewModel()
    @Namespace private var tabNamespace
    
    // UI State
    @State private var isMapExpanded = false
    @State private var selectedDetailPlace: HalalPlace?
    @State private var selectedDetailFood: HalalFood?
    
    // Feature Modals
    @State private var isShowingBarcodeScanner = false
    @State private var isShowingFoodCapture = false
    
    // MARK: - Computed Properties
    private var colors: ThemeModel { appEnv.theme.current }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Tab Selector
            HStack(spacing: 0) {
                ForEach(HalalTab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 8) {
                            Text(tab.rawValue)
                                .font(.system(size: 16, weight: viewModel.selectedTab == tab ? .bold : .medium))
                                .foregroundColor(viewModel.selectedTab == tab ? colors.primary : colors.foreground.opacity(0.4))
                            
                            // Animated Indicator
                            ZStack {
                                Capsule()
                                    .fill(Color.clear)
                                    .frame(height: 3)
                                
                                if viewModel.selectedTab == tab {
                                    Capsule()
                                        .fill(colors.primary)
                                        .frame(height: 3)
                                        .matchedGeometryEffect(id: "tab_indicator", in: tabNamespace)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 8)
            .background(colors.background)
            
            // MARK: - Screen Content Switcher
            if viewModel.selectedTab == .places {
                HalalPlacesTabView(
                    viewModel: viewModel,
                    isMapExpanded: $isMapExpanded,
                    selectedDetailPlace: $selectedDetailPlace,
                    colors: colors,
                    appEnv: appEnv
                )
            } else {
                HalalFoodTabView(
                    viewModel: viewModel,
                    selectedDetailFood: $selectedDetailFood,
                    colors: colors,
                    appEnv: appEnv
                )
            }
        }
        .background(colors.background.ignoresSafeArea())
        .navigationTitle(appEnv.language.localizedString("home_feature_halal"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                // Barcode Action (Food Tab Only)
                if viewModel.selectedTab == .food {
                    Button(action: { isShowingBarcodeScanner.toggle() }) {
                        Image(systemName: "barcode.viewfinder")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundColor(colors.primary)
                    .accessibilityLabel("Scan Barcode")
                    
                    // Capture Action
                    Button(action: { isShowingFoodCapture.toggle() }) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundColor(colors.primary)
                    .accessibilityLabel("Capture Food Photo")
                }
                
                // Map Toggle (Places Tab Only)
                if viewModel.selectedTab == .places {
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            isMapExpanded.toggle()
                        }
                    }) {
                        Image(systemName: isMapExpanded ? "list.bullet.below.rectangle" : "map.fill")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundColor(colors.primary)
                    .accessibilityLabel(isMapExpanded ? "Switch to list view" : "Expand map view")
                }
            }
        }
        .sheet(item: $selectedDetailPlace) { place in
            NavigationStack {
                HalalPlaceDetailView(place: place)
            }
        }
        .sheet(item: $selectedDetailFood) { food in
            NavigationStack {
                HalalFoodDetailView(food: food)
            }
        }
        .fullScreenCover(isPresented: $isShowingBarcodeScanner) {
            HalalScannerView(viewModel: viewModel, mode: .barcode)
        }
        .fullScreenCover(isPresented: $isShowingFoodCapture) {
            HalalScannerView(viewModel: viewModel, mode: .capture)
        }
    }
    
    // MARK: - Logic Helpers
    
    /// Redirects the user to the system settings app to enable camera permissions.
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationStack {
        HalalView()
            .environment(AppState())
    }
}
