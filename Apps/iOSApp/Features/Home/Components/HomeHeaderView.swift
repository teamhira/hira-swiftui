//
//  HomeHeaderView.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct HomeHeaderView: View {
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        VStack(spacing: 24) {
            // MARK: - Greeting Row
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(appEnv.language.localizedString("home_greeting_day"))
                        .font(.subheadline)
                        .foregroundColor(colors.foreground.opacity(0.5))
                    Text("Kira")
                        .font(.title3.bold())
                        .foregroundColor(colors.foreground)
                }
                Spacer()
                
                Button(action: {}) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.title3)
                            .foregroundColor(colors.primary)
                            .padding(10)
                            .background(Circle().fill(colors.primary.opacity(0.1)))
                        
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .offset(x: -2, y: 2)
                    }
                }
                .accessibilityLabel(appEnv.language.localizedString("home_accessibility_bell"))
            }
            
            // MARK: - Integrated Search Button
            Button(action: { router.navigate(to: .search) }) {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(colors.primary.opacity(0.6))
                        .font(.body.bold())
                    
                    Text(appEnv.language.localizedString("home_search_placeholder"))
                        .font(.subheadline)
                        .foregroundColor(colors.foreground.opacity(0.4))
                    
                    Spacer()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(colors.foreground.opacity(0.04)))
                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(colors.foreground.opacity(0.02), lineWidth: 1))
            }
            .accessibilityLabel(appEnv.language.localizedString("home_accessibility_search"))
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
}

#Preview {
    HomeHeaderView(colors: ThemeFactory.make(.green, isDark: false))
}
