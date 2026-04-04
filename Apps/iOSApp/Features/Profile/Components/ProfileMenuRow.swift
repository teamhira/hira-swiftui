//
//  ProfileMenuRow.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct ProfileMenuRow<Content: View>: View {
    let icon: String
    let title: String
    var value: String? = nil
    var showArrow: Bool = true
    var role: ButtonRole? = nil
    var trailingContent: Content? = nil
    let action: (() -> Void)?
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    // Standard Initializer (Action/Button)
    init(icon: String, title: String, value: String? = nil, showArrow: Bool = true, role: ButtonRole? = nil, action: @escaping () -> Void) where Content == EmptyView {
        self.icon = icon
        self.title = title
        self.value = value
        self.showArrow = showArrow
        self.role = role
        self.trailingContent = nil
        self.action = action
    }
    
    // Toggle Initializer
    init(icon: String, title: String, @ViewBuilder trailingContent: () -> Content) {
        self.icon = icon
        self.title = title
        self.value = nil
        self.showArrow = false
        self.role = nil
        self.trailingContent = trailingContent()
        self.action = nil
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // MARK: - Icon Background
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(role == .destructive ? Color.red.opacity(0.1) : colors.primary.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(role == .destructive ? .red : colors.primary)
            }
            
            // MARK: - Title
            Text(title)
                .font(TextStyle.body.bold())
                .foregroundColor(role == .destructive ? .red : colors.foreground)
            
            Spacer()
            
            // MARK: - Trailing Area
            if let content = trailingContent {
                content
            } else {
                HStack(spacing: 8) {
                    if let value = value {
                        Text(value)
                            .font(TextStyle.footnote)
                            .foregroundColor(colors.foreground.opacity(0.4))
                    }
                    
                    if showArrow {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(colors.foreground.opacity(0.2))
                    }
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.md - 2)
        .hiraCleanCard(colors: colors, radius: 20)
        .contentShape(Rectangle())
        .onTapGesture {
            if let action = action {
                action()
            }
        }
    }
}
