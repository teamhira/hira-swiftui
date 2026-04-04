//
//  QiblaCompassStyle.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

public struct QiblaCompassStyle: Identifiable, Equatable {
    public let id = UUID()
    public let name: String
    public let icon: String
    public let color: Color
    public let secondaryColor: Color
    
    public static let availableStyles: [QiblaCompassStyle] = [
        QiblaCompassStyle(name: "Emerald Divine", icon: "qibla_green", color: Color.green, secondaryColor: Color.mint),
        QiblaCompassStyle(name: "Classic White", icon: "qibla_white", color: Color.white, secondaryColor: Color.gray.opacity(0.3)),
        QiblaCompassStyle(name: "Rose Gold", icon: "qibla_gold", color: Color(hex: "B76E79"), secondaryColor: Color(hex: "FFB7C5")),
        QiblaCompassStyle(name: "Deep Ocean", icon: "qibla_blue", color: Color.blue, secondaryColor: Color.cyan),
        QiblaCompassStyle(name: "Ebony Gold", icon: "qibla_black", color: Color(hex: "D4AF37"), secondaryColor: Color.black)
    ]
}
