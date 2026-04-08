//
//  Int+Formatting.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation

extension Int {
    /// Formats the integer with a thousands separator (dot).
    public var formattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
