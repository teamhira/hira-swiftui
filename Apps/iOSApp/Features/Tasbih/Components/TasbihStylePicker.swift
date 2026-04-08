//
//  TasbihStylePicker.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct TasbihStylePicker: View {
    @Environment(\.appEnvironment) private var appEnv
    @Binding var selectedStyle: TasbihBeadStyle
    let onDhikrTap: () -> Void
    let onHaptic: (UIImpactFeedbackGenerator.FeedbackStyle) -> Void
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) { // Slightly tighter spacing
            // Header
            HStack {
                Text(appEnv.language.localizedString("tasbih_dhikr"))
                    .font(.headline)
                    .foregroundColor(colors.foreground)
                
                Spacer()
                
                Button(action: onDhikrTap) {
                    Text(appEnv.language.localizedString("tasbih_view_all"))
                        .font(.caption.bold())
                        .foregroundColor(colors.primary)
                }
            }
            .padding(.horizontal, 24)
            
            // horizontal scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(TasbihBeadStyle.availableStyles) { style in
                        styleCircle(style)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12) // Increased to prevent shadow clipping
            }
            .frame(height: 100) // Increased height to accommodate vertical padding and shadows
        }
        .padding(.top, AppSpacing.md)
        .padding(.bottom, AppSpacing.md)
        .hiraCleanCard(colors: colors, radius: 32)
        .padding(.horizontal, AppSpacing.md)
    }
    
    private func styleCircle(_ style: TasbihBeadStyle) -> some View {
        Button(action: { 
            withAnimation(.spring()) { selectedStyle = style } 
            onHaptic(.soft)
        }) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(LinearGradient(colors: style.colors, 
                                       startPoint: .topLeading, 
                                       endPoint: .bottomTrailing))
                    .frame(width: 58, height: 58)
                    .overlay(
                        Circle()
                            .stroke(style == selectedStyle ? colors.primary : Color.clear, lineWidth: 3)
                    )
                    .shadow(color: style == selectedStyle ? colors.primary.opacity(0.3) : .clear, radius: 8)
                
                if style.isPremium {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                        .padding(4)
                        .background(colors.primary)
                        .clipShape(Circle())
                        .offset(x: 4, y: 4)
                }
            }
        }
    }
}
