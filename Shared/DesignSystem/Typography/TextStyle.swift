//
//  TextStyle.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import SwiftUI

enum TextStyle {

    // MARK: - System / Latin Fonts
    
    /// Large display title (e.g., Home screen greeting)
    static let display = AppFont.system(34, weight: .bold)
    
    /// Title 1 - Main navigation and header titles
    static let title1 = AppFont.system(28, weight: .bold)
    
    /// Title 2 - Section headers
    static let title2 = AppFont.system(22, weight: .bold)
    
    /// Title 3 - Sub-headers or card titles
    static let title3 = AppFont.system(20, weight: .semibold)
    
    /// Headline - Used for prominent list items
    static let headline = AppFont.system(17, weight: .semibold)
    
    /// Body - Default reading text (e.g., translation text)
    static let body = AppFont.system(16, weight: .regular)
    
    /// Callout - Slightly smaller body text for emphasis
    static let callout = AppFont.system(15, weight: .regular)
    
    /// Subheadline - Small section headers or text below titles
    static let subheadline = AppFont.system(15, weight: .regular)
    
    /// Footnote - Small references or metadata
    static let footnote = AppFont.system(13, weight: .regular)
    
    /// Caption 1 - Standard small descriptive text
    static let caption = AppFont.system(12, weight: .regular)
    
    /// Caption 2 - Alternative minimal text
    static let caption2 = AppFont.system(11, weight: .regular)

    // MARK: - Arabic / Quranic Fonts
    
    /// Arabic Large Title (e.g., Surah name in header)
    static let arabicTitle = AppFont.arabic(32, weight: .bold)
    
    /// Arabic Aya Large - Main Quran reading text
    static let arabicAyaLarge = AppFont.arabic(36, weight: .regular)
    
    /// Arabic Aya Medium - Compressed Quran reading view
    static let arabicAyaMedium = AppFont.arabic(28, weight: .regular)
    
    /// Arabic Aya Small - Small snippets or list previews
    static let arabicAyaSmall = AppFont.arabic(22, weight: .regular)
    
    /// Arabic Body - Normal Arabic text for instructions or notes
    static let arabicBody = AppFont.arabic(20, weight: .medium)
    
    /// Arabic Subheadline - Smaller Arabic text
    static let arabicSubheadline = AppFont.arabic(16, weight: .medium)

    // MARK: - Legacy (Keeping original names for compatibility)
    static let title = title3
    static let arabicLarge = AppFont.arabic(28, weight: .semibold)
    static let arabicMedium = AppFont.arabic(22)
}

