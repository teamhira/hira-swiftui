//
//  WaveformAnimationView.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI

public struct WaveformAnimationView: View {
    let color: Color
    @State private var phase: CGFloat = 0
    
    public init(color: Color) {
        self.color = color
    }
    
    public var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<5) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: 3)
                    .frame(height: 10 + sin(phase + CGFloat(i)) * 8)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}
