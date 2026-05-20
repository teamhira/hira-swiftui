//
//  FeaturedDuaView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct FeaturedDuaView: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    private var colors: ThemeModel { appEnv.theme.current }
    
    let item: DuaEntity?
    let isLoading: Bool
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if isLoading {
                VStack(alignment: .leading, spacing: 12) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colors.primary.opacity(0.1))
                        .frame(width: 100, height: 20)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colors.foreground.opacity(0.1))
                        .frame(height: 32)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colors.foreground.opacity(0.05))
                        .frame(height: 60)
                }
                .hiraShimmer()
            } else if let item = item {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 12) {
                            // Feature Tag
                            Text(appEnv.language.localizedString("dua_featured_tag"))
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(colors.primary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(colors.primary.opacity(0.1))
                                .clipShape(Capsule())
                            
                            Text(item.title)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(colors.foreground)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 40))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(colors.primary)
                            .padding(.top, 4)
                    }
                    
                    Text(item.translation)
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    Button(action: {
                        router.navigate(to: .duaDetail(item))
                    }) {
                        HStack {
                            Text(appEnv.language.localizedString("dua_see_detail"))
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(colors.primary)
                        .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(colors.primary.opacity(0.05))
        )
        .padding(.horizontal, 24)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(item?.title ?? "")
    }
}

#Preview {
    FeaturedDuaView(
        item: DuaEntity(
            id: 1,
            category: "morning",
            title: "Morning Remembrance",
            arabic: "...",
            transliteration: "...",
            translation: "We have reached the morning...",
            source: "Abu Dawud",
            repeatOnce: 1
        ),
        isLoading: false
    )
}

