//
//  TasbihBeadCanvas.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct TasbihBeadCanvas: View {
    @Environment(\.appEnvironment) private var appEnv
    let style: TasbihBeadStyle
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    
    // Internal offset for interactive sliding
    @State private var dragOffset: CGFloat = 0
    @State private var advanceAnimation: CGFloat = 0 // Used to "pulse" beads on count
    
    private var colors: ThemeModel { appEnv.theme.current }
    private let beadSize: CGFloat = 58
    private let beadSpacing: CGFloat = 72
    
    // Path Constants for exact alignment
    private let curveHeight: CGFloat = 60
    private let startYOffset: CGFloat = 20
    private let endYOffset: CGFloat = -60
    private let controlYOffset: CGFloat = -20
    private let extraWidth: CGFloat = 100
    
    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
            let h = geometry.size.height
            let midY = h / 2
            
            ZStack {
                // The String Path (Visual Guide)
                Path { path in
                    path.move(to: CGPoint(x: -extraWidth, y: midY + startYOffset))
                    path.addQuadCurve(
                        to: CGPoint(x: w + extraWidth, y: midY + endYOffset),
                        control: CGPoint(x: w / 2, y: midY + controlYOffset)
                    )
                }
                .stroke(colors.foreground.opacity(0.1), lineWidth: 2)
                
                // Beads on the path
                ForEach(-4...4, id: \.self) { index in
                    beadShape(at: index, totalWidth: w, totalHeight: h)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        let threshold: CGFloat = 60
                        
                        if value.translation.width < -threshold {
                            advanceBeads(direction: -1)
                            onIncrement()
                        } else if value.translation.width > threshold {
                            advanceBeads(direction: 1)
                            onDecrement()
                        }
                        
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7)) {
                            dragOffset = 0
                        }
                    }
            )
            .onTapGesture {
                advanceBeads(direction: -1)
                onIncrement()
            }
        }
    }
    
    private func advanceBeads(direction: CGFloat) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            advanceAnimation = direction * 20
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                advanceAnimation = 0
            }
        }
    }
    
    private func beadShape(at index: Int, totalWidth: CGFloat, totalHeight: CGFloat) -> some View {
        let midX = totalWidth / 2
        let midY = totalHeight / 2
        
        let baseOffset = CGFloat(index) * beadSpacing
        let currentOffset = baseOffset + dragOffset + advanceAnimation
        
        // Exact X position
        let xPos = midX + currentOffset
        
        // Calculate 't' (0 to 1) for the Bezier path interpolation
        // The path goes from -extraWidth to totalWidth + extraWidth
        let fullWidth = totalWidth + (2 * extraWidth)
        let t = (xPos + extraWidth) / fullWidth
        
        // Quadratic Bezier Formula: (1-t)^2*P0 + 2(1-t)*t*P1 + t^2*P2
        let y0 = midY + startYOffset
        let y1 = midY + controlYOffset
        let y2 = midY + endYOffset
        
        let quadY = pow(1 - t, 2) * y0 + 2 * (1 - t) * t * y1 + pow(t, 2) * y2
        
        let normalizedX = currentOffset / (totalWidth / 1.5)
        let scale = 1.0 - abs(normalizedX) * 0.12
        let opacity = 1.0 - abs(normalizedX) * 0.4
        
        return ZStack {
            // Shadow
            Circle()
                .fill(Color.black.opacity(0.3))
                .blur(radius: 6)
                .offset(y: 8)
                .scaleEffect(0.9)
            
            // High-fidelity Bead
            Circle()
                .fill(
                    LinearGradient(colors: style.colors, 
                                   startPoint: .topLeading, 
                                   endPoint: .bottomTrailing)
                )
                .overlay(
                    Circle()
                        .stroke(LinearGradient(colors: [.white.opacity(0.5), .clear], 
                                             startPoint: .topLeading, 
                                             endPoint: .bottomTrailing), lineWidth: 1.5)
                )
                .overlay(
                    Circle()
                        .fill(RadialGradient(gradient: Gradient(colors: [.white.opacity(0.4), .clear]), 
                                           center: .init(x: 0.25, y: 0.25), 
                                           startRadius: 2, 
                                           endRadius: 20))
                )
        }
        .frame(width: beadSize, height: beadSize)
        .scaleEffect(scale)
        .opacity(opacity)
        .position(x: xPos, y: quadY) // Use position for absolute coordinate matching
        .blur(radius: abs(normalizedX) * 0.5)
    }
}
