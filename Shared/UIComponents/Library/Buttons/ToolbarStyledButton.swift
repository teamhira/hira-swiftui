//
//  ToolbarStyledButton.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

/// A reusable circular toolbar button used across the Hira application.
public struct ToolbarStyledButton: View {
    @Environment(\.appEnvironment) private var appEnv
    public let icon: String
    public let action: () -> Void
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init(icon: String, action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(colors.primary)
                .frame(width: 36, height: 36)
                .background(colors.primary.opacity(0.1))
                .clipShape(Circle())
        }
    }
}
