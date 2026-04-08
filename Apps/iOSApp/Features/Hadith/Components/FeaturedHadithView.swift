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
    private var colors: ThemeModel { appEnv.theme.current }
    
    let title: String
    let bodyText: String
    let source: String
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(appEnv.language.localizedString(title))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(colors.foreground)
                    
                    Text(source)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
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
            
            Text(appEnv.language.localizedString(bodyText))
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .italic()
                .foregroundColor(colors.foreground.opacity(0.8))
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(colors.primary.opacity(0.05))
        )
        .padding(.horizontal, 24)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(appEnv.language.localizedString(title))
        .accessibilityHint(appEnv.language.localizedString(bodyText))
    }
}
