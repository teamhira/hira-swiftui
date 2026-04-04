//
//  AppShadow.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

enum AppShadow {

    // MARK: - Base Shadows
    static let xs = ShadowStyle(
        color: Color.black.opacity(0.05),
        radius: 2,
        x: 0,
        y: 1
    )

    static let sm = ShadowStyle(
        color: Color.black.opacity(0.08),
        radius: 4,
        x: 0,
        y: 2
    )

    static let md = ShadowStyle(
        color: Color.black.opacity(0.12),
        radius: 8,
        x: 0,
        y: 4
    )

    static let lg = ShadowStyle(
        color: Color.black.opacity(0.16),
        radius: 16,
        x: 0,
        y: 8
    )

    // MARK: - Component Shadows
    static let card = md
    static let button = sm
    static let modal = lg

    // MARK: - Special (Quran App)
    static let floatingPlayer = ShadowStyle(
        color: Color.black.opacity(0.2),
        radius: 12,
        x: 0,
        y: 6
    )
}
