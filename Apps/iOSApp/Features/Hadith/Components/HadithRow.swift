//
//  HadithRow.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct HadithRow: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    let title: String
    let bodyText: String
    let narrator: String
    let source: String
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header with narrator
            HStack {
                Text(appEnv.language.localizedString("hadith_narrated_by", arguments: [narrator]))
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(colors.primary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(colors.primary.opacity(0.1))
                    .clipShape(Capsule())
                
                Spacer()
                
                Text(source)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.secondary)
                    .opacity(0.6)
            }
            
            // Title and body preview
            VStack(alignment: .leading, spacing: 6) {
                Text(LocalizedStringKey(title))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(colors.foreground)
                
                Text(LocalizedStringKey(bodyText))
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(18)
        .background(colors.background)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .hiraCleanCard(colors: colors)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityHint(appEnv.language.localizedString("hadith_accessibility_item"))
    }
}
