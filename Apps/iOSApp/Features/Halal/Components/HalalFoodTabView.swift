//
//  HalalFoodTabView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

/// Sub-view for the Food tab in Halal Finder.
public struct HalalFoodTabView: View {
    // MARK: - Properties
    @Bindable var viewModel: HalalViewModel
    @Binding var selectedDetailFood: HalalFood?
    let colors: ThemeModel
    let appEnv: AppEnvironment
    
    // MARK: - Body
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // 1. Food Search Card
                HalalPlaceFilterCard(searchText: $viewModel.foodSearchText, colors: colors)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                
                // 2. Food Results Discovery List
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(appEnv.language.localizedString("halal_tab_food"))
                            .font(.headline.bold())
                            .foregroundColor(colors.foreground)
                        
                        Spacer()
                        
                        Text("\(viewModel.filteredFoodItems.count) Results")
                            .font(.caption.bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(colors.primary.opacity(0.1))
                            .foregroundColor(colors.primary)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 24)
                    
                    VStack(spacing: 0) {
                        ForEach(viewModel.filteredFoodItems) { food in
                            HalalFoodListItem(
                                food: food,
                                colors: colors,
                                onTap: { selectedDetailFood = food }
                            )
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                            
                            if food != viewModel.filteredFoodItems.last {
                                Divider()
                                    .padding(.leading, 72)
                                    .padding(.trailing, 24)
                                    .opacity(0.3)
                            }
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .alert(appEnv.language.localizedString("camera_permission_title"), isPresented: $viewModel.showPermissionAlert) {
            Button(appEnv.language.localizedString("camera_permission_settings"), action: openSettings)
            Button(appEnv.language.localizedString("common_cancel"), role: .cancel) { }
        } message: {
            Text(appEnv.language.localizedString("camera_permission_message"))
        }
    }
    
    // MARK: - Logic Helpers
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
