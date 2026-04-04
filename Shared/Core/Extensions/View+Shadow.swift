//
//  View+Shadow.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

extension View {
    func shadow(_ style: ShadowStyle) -> some View {
        self.shadow(
            color: style.color,
            radius: style.radius,
            x: style.x,
            y: style.y
        )
    }
}
