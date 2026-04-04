//
//  AppFont.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

enum AppFont {

    static func arabic(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .medium:
            return .custom("NotoNaskhArabic-Medium", size: size)
        case .semibold:
            return .custom("NotoNaskhArabic-SemiBold", size: size)
        case .bold:
            return .custom("NotoNaskhArabic-Bold", size: size)
        default:
            return .custom("NotoNaskhArabic-Regular", size: size)
        }
    }

    static func system(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .system(size: size, weight: weight)
    }
}
