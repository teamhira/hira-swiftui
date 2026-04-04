//
//  CharityStatBadge.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct CharityStatBadge: View {
    let icon: String
    let value: String
    let label: String
    var isTarget: Bool = false
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                Text(label)
                    .font(.system(size: 10, weight: .bold))
            }
            .foregroundColor(.secondary)
            
            Text(value)
                .font(.subheadline.bold())
                .foregroundColor(isTarget ? .green : colors.foreground)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colors.foreground.opacity(0.04))
        .cornerRadius(12)
    }
}
