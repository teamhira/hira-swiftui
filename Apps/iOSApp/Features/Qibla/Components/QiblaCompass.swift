//
//  QiblaCompass.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct QiblaCompass: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    let heading: Double
    let qiblaDirection: Double
    let isFacing: Bool
    let style: QiblaCompassStyle
    
    // MARK: - Computed Properties
    private var colors: ThemeModel { appEnv.theme.current }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Shadow Glow
            Circle()
                .fill(style.color.opacity(isFacing ? 0.2 : 0))
                .frame(width: 260, height: 260)
                .blur(radius: isFacing ? 20 : 0)
                .animation(.easeInOut(duration: 0.5), value: isFacing)
            
            // Dial rotates to North
            ZStack {
                Circle()
                    .stroke(colors.foreground.opacity(0.1), lineWidth: 1)
                    .frame(width: 220, height: 220)
                
                // Markers
                ForEach(0..<72) { i in
                    Rectangle()
                        .fill(colors.foreground.opacity(i % 9 == 0 ? 0.3 : 0.1))
                        .frame(width: i % 9 == 0 ? 2 : 1, height: i % 9 == 0 ? 10 : 6)
                        .offset(y: -100)
                        .rotationEffect(.degrees(Double(i) * 5))
                }
                
                // Cardinals
                ForEach(["N", "E", "S", "W"], id: \.self) { card in
                    Text(card)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(colors.foreground.opacity(card == "N" ? 0.8 : 0.4))
                        .offset(y: -82)
                        .rotationEffect(.degrees(cardAngle(card)))
                }
            }
            .rotationEffect(.degrees(-heading))
            
            // MARK: - Kaaba Target
            Image(systemName: "square.fill")
                .font(.system(size: 20))
                .foregroundColor(style.color)
                .offset(y: -100)
                .rotationEffect(.degrees(qiblaDirection - heading))
                .shadow(color: style.color.opacity(0.5), radius: 8)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: heading)
            
            // Needle points to Mecca
            ZStack {
                VStack(spacing: 0) {
                    Triangle()
                        .fill(isFacing ? style.color : style.secondaryColor)
                        .frame(width: 32, height: 80)
                    
                    Rectangle()
                        .fill(isFacing ? style.color.opacity(0.8) : style.secondaryColor.opacity(0.5))
                        .frame(width: 1.5, height: 30)
                }
                .offset(y: -40)
                
                Circle()
                    .fill(colors.background)
                    .frame(width: 10, height: 10)
                    .overlay(Circle().stroke(style.color, lineWidth: 2))
            }
            .rotationEffect(.degrees(qiblaDirection - heading))
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: heading)
        }
        .frame(width: 240, height: 240)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(appEnv.language.localizedString("qibla_compass_accessibility_label", defaultValue: "Qibla Compass"))
        .accessibilityValue(
            String(format: appEnv.language.localizedString("qibla_compass_accessibility_value_format", defaultValue: "Heading %d degrees, Qibla at %d degrees. %@"), 
                   Int(heading), Int(qiblaDirection), 
                   isFacing ? appEnv.language.localizedString("qibla_facing_mecca_success", defaultValue: "You're now facing Mecca") : "")
        )
    }
    
    // MARK: - Helpers
    private func cardAngle(_ card: String) -> Double {
        switch card {
            case "N": return 0
            case "E": return 90
            case "S": return 180
            case "W": return 270
            default: return 0
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
