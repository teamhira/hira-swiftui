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
    
    let item: HadithEntity
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header with source
            HStack {
                Text(LocalizedStringKey(item.collectionName))
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(colors.primary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(colors.primary.opacity(0.1))
                    .clipShape(Capsule())
                
                Spacer()
                
                Text("#\(item.hadithnumber)")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.secondary)
                    .opacity(0.6)
            }
            
            // Body preview
            VStack(alignment: .leading, spacing: 6) {
                Text(item.english)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(colors.foreground)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                
                if !item.arabic.isEmpty {
                    Text(item.arabic)
                        .font(.custom("KFGQPCUthmanTahaNaskh-Regular", size: 16))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
        .padding(18)
        .background(colors.background)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .hiraCleanCard(colors: colors)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.collectionName) \(item.hadithnumber)")
        .accessibilityHint(item.english)
    }
}
