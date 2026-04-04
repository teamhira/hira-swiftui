//
//  ThemeFactory.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct ThemeFactory {

    public static func make(_ variant: ThemeVariant, isDark: Bool) -> ThemeModel {

        let base = baseColorsFor(variant: variant)

        return ThemeModel(
            primary: base.primary,
            primaryForeground: Color("PrimaryForegroundColor"), // Dinamis dari Assets
            secondary: base.secondary,

            background: Color("BackgroundColor"),
            foreground: Color("ForegroundColor"),

            card: Color("CardColor"),
            cardForeground: Color("CardForegroundColor"),

            accent: Color("AccentColor"),
            accentForeground: Color("AccentForegroundColor"),

            destructive: Color("DestructiveColor"),

            border: Color("BorderColor"),
            input: Color("InputColor"),
            ring: Color("RingColor"),

            // Quran
            ayahText: Color("AyahTextColor"),
            ayahHighlight: Color("AyahHighlightColor"),
            playbackActive: Color("PlaybackActiveColor"),
            downloadProgress: Color("DownloadProgressColor")
        )
    }

    /// Provides the base primary and secondary colors for a given variant
    public static func baseColorsFor(variant: ThemeVariant) -> (primary: Color, secondary: Color) {
        switch variant {
        case .green:
            return (
                Color(hex: "#034C53"),
                Color(hex: "#007074")
            )
        case .blue:
            return (
                Color(hex: "#647FBC"),
                Color(hex: "#91ADC8")
            )
        case .brown:
            return (
                Color(hex: "#706233"),
                Color(hex: "#B0926A")
            )
        case .teal:
            return (
                Color(hex: "#89A8B2"),
                Color(hex: "#B3C8CF")
            )
        case .pink:
            return (
                Color(hex: "#FF90BB"),
                Color(hex: "#FFC1DA")
            )
        }
    }
}
