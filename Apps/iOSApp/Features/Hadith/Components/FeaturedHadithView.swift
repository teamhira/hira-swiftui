//
//  FeaturedHadithView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct FeaturedHadithView: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    private var colors: ThemeModel { appEnv.theme.current }
    
    let item: HadithEntity
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(appEnv.language.localizedString("hadith_featured_title"))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(colors.foreground)
                    
                    Text(item.collectionName)
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(colors.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(colors.primary.opacity(0.1))
                        .clipShape(Capsule())
                }
                
                Spacer()
                
                Image(systemName: "quote.bubble.fill")
                    .font(.system(size: 32))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(colors.primary)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                if !item.arabic.isEmpty {
                    Text(item.arabic)
                        .font(.custom("KFGQPCUthmanTahaNaskh-Regular", size: 24))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(colors.foreground)
                        .lineLimit(2)
                        .lineSpacing(6)
                }
                
                Text(item.english)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .italic()
                    .foregroundColor(colors.foreground.opacity(0.8))
                    .lineLimit(3)
                    .lineSpacing(4)
                
                Button(action: {
                    router.navigate(to: .hadithDetail(item))
                }) {
                    HStack {
                        Text(appEnv.language.localizedString("dua_see_detail")) // Recycled key
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
                .padding(.top, 4)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(colors.primary.opacity(0.05))
        )
        .padding(.horizontal, 24)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(appEnv.language.localizedString("hadith_featured_title"))
        .accessibilityHint(item.english)
    }
}
