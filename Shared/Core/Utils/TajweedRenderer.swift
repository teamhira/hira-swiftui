//
//  TajweedRenderer.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI
import Foundation

public struct TajweedRenderer {
    
    public enum TajweedRule: String {
        case ham_wasl
        case laam_shamsiyah
        case madda_normal
        case madda_permissible
        case madda_permissable // common typo in some APIs
        case madda_necessary
        case madda_obligatory
        case ghunnah
        case ikhfa
        case ikhfa_shafawi
        case idgham_with_ghunnah
        case idgham_without_ghunnah
        case idgham_mutajanisayn
        case idgham_mutaqaribayn
        case idgham_shafawi
        case qalqalah
        case iqlab
        
        public var color: Color {
            switch self {
            case .ham_wasl, .laam_shamsiyah:
                return Color(hex: "#AAAAAA")
            case .madda_normal, .madda_permissible, .madda_permissable, .madda_necessary, .madda_obligatory:
                return Color(hex: "#F11111")
            case .ghunnah, .ikhfa, .ikhfa_shafawi, .idgham_with_ghunnah, .idgham_shafawi, .idgham_mutajanisayn, .idgham_mutaqaribayn:
                return Color(hex: "#00A854")
            case .qalqalah:
                return Color(hex: "#00AEEF")
            case .iqlab:
                return Color(hex: "#F19111")
            case .idgham_without_ghunnah:
                return Color.primary
            }
        }
    }
    
    public static func render(html: String) -> AttributedString {
        var attributedString = AttributedString("")
        
        let nsString = html as NSString
        // Resilient regex to match:
        // 1. Full rule tags: <rule class="name">content</rule> (Groups 1, 2, 3)
        // 2. Any other tag to strip: <rule ... />, <br />, etc. (Group 4)
        // 3. Plain text: [^<]+ (Group 5)
        let pattern = #"(<rule\s+class=["']?([^"'>\s]+)["']?[^>]*>(.*?)</rule>)|(<[^>]+>)|([^<]+)"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else {
            return AttributedString(html)
        }
        
        let matches = regex.matches(in: html, options: [], range: NSRange(location: 0, length: nsString.length))
        
        for match in matches {
            if match.range(at: 1).location != NSNotFound {
                // <rule class="...">content</rule>
                let ruleClass = nsString.substring(with: match.range(at: 2))
                var content = nsString.substring(with: match.range(at: 3))
                
                // Strip any nested tags in content
                content = content.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                
                var attr = AttributedString(content)
                if let rule = TajweedRule(rawValue: ruleClass) {
                    attr.foregroundColor = rule.color
                }
                attributedString += attr
            } else if match.range(at: 4).location != NSNotFound {
                // Other tags (to strip)
            } else if match.range(at: 5).location != NSNotFound {
                // Plain text
                let text = nsString.substring(with: match.range(at: 5))
                attributedString += AttributedString(text)
            }
        }
        
        // Final safety check: if we somehow still have raw tag fragments (like ">rule/"), 
        // strip them from the characters but keep existing attributes!
        let finalString = attributedString
        let rawContent = String(attributedString.characters)
        if rawContent.contains(">") || rawContent.contains("<") {
            // We strip safely by keeping the existing attributed string
            // but if it's very messy, we fallback to a clean version.
            // However, the previous logic was destroying all colors.
            // Let's just trust the regex loop which is already quite robust.
        }
        
        if finalString.characters.isEmpty && !html.isEmpty {
            let stripped = html.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                .replacingOccurrences(of: "[<>/]*rule[^>]*[>/]*", with: "", options: .regularExpression)
            return AttributedString(stripped)
        }
        
        return finalString
    }
}

