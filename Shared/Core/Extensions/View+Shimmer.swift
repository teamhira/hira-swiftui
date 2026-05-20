//
//  View+Shimmer.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import SwiftUI

public struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        Color.white.opacity(0.3)
                            .mask(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: .clear, location: 0),
                                        .init(color: .white.opacity(0.5), location: 0.5),
                                        .init(color: .clear, location: 1)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .frame(width: geometry.size.width * 2)
                                .offset(x: -geometry.size.width + (geometry.size.width * 2 * phase))
                            )
                    }
                }
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

public extension View {
    /// Applies a premium shimmer effect to the view, typically used for loading states.
    func hiraShimmer() -> some View {
        self.modifier(ShimmerModifier())
    }
}
