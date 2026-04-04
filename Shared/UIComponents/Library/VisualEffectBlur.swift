//
//  VisualEffectBlur.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

public struct VisualEffectBlur: UIViewRepresentable {
    public var blurStyle: UIBlurEffect.Style
    
    public init(blurStyle: UIBlurEffect.Style = .systemMaterial) {
        self.blurStyle = blurStyle
    }
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}
