//
//  HalalFoodDetailView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

/// Detail view for a specific Halal food product.
public struct HalalFoodDetailView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appEnvironment) private var appEnv
    public let food: HalalFood
    
    // MARK: - Computed Properties
    private var colors: ThemeModel { appEnv.theme.current }
    
    // MARK: - Body
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // MARK: - Header Header
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(colors.primary.opacity(0.05))
                            .frame(height: 200)
                        
                        Image(systemName: "tag.fill")
                            .font(.system(size: 80))
                            .foregroundColor(colors.primary.opacity(0.4))
                    }
                    
                    VStack(spacing: 8) {
                        Text(food.name)
                            .font(.title2.bold())
                            .foregroundColor(colors.foreground)
                        
                        Text(food.brand)
                            .font(.headline)
                            .foregroundColor(colors.foreground.opacity(0.6))
                    }
                }
                
                // MARK: - Status Card
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Halal Status")
                            .font(.caption.bold())
                            .foregroundColor(colors.foreground.opacity(0.4))
                        
                        Text(food.status)
                            .font(.title3.bold())
                            .foregroundColor(statusColor)
                    }
                    
                    Spacer()
                    
                    Image(systemName: food.status == "Certified" ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                        .font(.title)
                        .foregroundColor(statusColor)
                }
                .padding(20)
                .background(colors.card)
                .cornerRadius(20)
                .hiraCleanCard(colors: colors)
                
                // MARK: - Description & Meta
                VStack(alignment: .leading, spacing: 16) {
                    Text("Product Details")
                        .font(.headline.bold())
                        .foregroundColor(colors.foreground)
                    
                    VStack(spacing: 16) {
                        detailRow(title: "Category", value: food.category)
                        detailRow(title: "ID", value: food.id.uuidString.prefix(8).uppercased())
                    }
                    .padding(20)
                    .background(colors.card)
                    .cornerRadius(20)
                    .hiraCleanCard(colors: colors)
                }
            }
            .padding(24)
        }
        .background(colors.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(colors.primary)
                }
            }
        }
    }
    
    // MARK: - Helper Views
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(colors.foreground.opacity(0.5))
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .foregroundColor(colors.foreground)
        }
    }
    
    private var statusColor: Color {
        switch food.status {
        case "Certified": return .green
        case "Pending": return .orange
        case "Doubtful": return .red
        default: return .gray
        }
    }
}
