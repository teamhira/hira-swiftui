//
//  TarteelRecordButton.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI

public struct TarteelRecordButton: View {
    @Binding var isRecording: Bool
    let action: () -> Void
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init(isRecording: Binding<Bool>, action: @escaping () -> Void) {
        self._isRecording = isRecording
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isRecording ? Color.red : colors.primary)
                    .frame(width: 72, height: 72)
                    .shadow(color: (isRecording ? Color.red : colors.primary).opacity(0.3), radius: 10, y: 5)
                
                if isRecording {
                    WaveformAnimationView(color: .white)
                        .scaleEffect(1.2)
                } else {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .buttonStyle(TarteelScaleButtonStyle())
    }
}

struct TarteelScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
