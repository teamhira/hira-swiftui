//
//  PINView.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

public enum PINMode: Hashable {
    case create
    case verify(String)
    case unlock
    case change
}

public struct PINView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.appEnvironment) private var appEnv
    
    // MARK: - State
    @State private var mode: PINMode
    @State private var pin: String = ""
    @State private var animateItems = false
    @State private var shakeTrigger = false
    
    private var colors: ThemeModel { appEnv.theme.current }
    private let maxDigits = 6
    
    public init(mode: PINMode = .unlock) {
        _mode = State(initialValue: mode)
    }
    
    public var body: some View {
        ZStack {
            BackgroundVisuals(animate: $animateItems)
            
            VStack(spacing: 0) {
                // MARK: - Header
                PINHeader(mode: mode)
                    .padding(.top, 40)
                    .padding(.bottom, 48)
                    .accessibilityElement(children: .combine)
                
                // MARK: - Indicators
                PINIndicatorView(pinCount: pin.count, maxDigits: maxDigits)
                    .modifier(ShakeEffect(animatableData: shakeTrigger ? 1 : 0))
                    .padding(.bottom, 60)
                    .accessibilityLabel("PIN entry progress")
                    .accessibilityValue("\(pin.count) of \(maxDigits) digits entered")
                
                Spacer()
                
                // MARK: - Numpad
                PINNumpadView(
                    mode: mode,
                    onPress: handlePress,
                    onBackspace: handleBackspace,
                    onFaceID: handleFaceID
                )
                .padding(.bottom, 30)
                .padding(.horizontal, 40)
            }
        }
        .onAppear {
            _ = appEnv.language.selectedCode // Explicit observation
            withAnimation(.easeInOut(duration: 0.8)) { animateItems = true }
        }
    }
    
    private func handlePress(_ digit: String) {
        guard pin.count < maxDigits else { return }
        withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
            pin.append(digit)
        }
        
        UIAccessibility.post(notification: .announcement, argument: "Digit \(pin.count) entered")
        
        if pin.count == maxDigits {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                processPIN()
            }
        }
    }
    
    private func processPIN() {
        switch mode {
        case .create:
            let firstPIN = pin
            withAnimation {
                mode = .verify(firstPIN)
                pin = ""
            }
            UIAccessibility.post(notification: .announcement, argument: appEnv.language.localizedString("pin_mode_verify_title"))
            
        case .verify(let originalPIN):
            if pin == originalPIN {
                appEnv.security.storedPIN = pin
                appEnv.security.isPINSet = true
                UIAccessibility.post(notification: .announcement, argument: "PIN Success")
                router.pop()
            } else {
                failPIN()
            }
            
        case .unlock:
            if pin == appEnv.security.storedPIN {
                router.popToRoot()
            } else {
                failPIN()
            }
            
        case .change:
            if pin == appEnv.security.storedPIN {
                withAnimation {
                    mode = .create
                    pin = ""
                }
            } else {
                failPIN()
            }
        }
    }
    
    private func failPIN() {
        withAnimation(.default) {
            shakeTrigger.toggle()
            pin = ""
        }
        UIAccessibility.post(notification: .announcement, argument: "Incorrect PIN")
    }
    
    private func handleBackspace() {
        guard !pin.isEmpty else { return }
        pin.removeLast()
    }
    
    private func handleFaceID() {
        // Biometric logic
    }
}

// MARK: - Subcomponents
private struct PINHeader: View {
    let mode: PINMode
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var title: String {
        switch mode {
        case .create: return appEnv.language.localizedString("pin_mode_create_title")
        case .verify: return appEnv.language.localizedString("pin_mode_verify_title")
        case .unlock: return appEnv.language.localizedString("pin_mode_unlock_title")
        case .change: return appEnv.language.localizedString("pin_mode_change_title")
        }
    }
    
    var subtitle: String {
        switch mode {
        case .create: return appEnv.language.localizedString("pin_mode_create_subtitle")
        case .verify: return appEnv.language.localizedString("pin_mode_verify_subtitle")
        case .unlock: return appEnv.language.localizedString("pin_mode_unlock_subtitle")
        case .change: return appEnv.language.localizedString("pin_mode_change_subtitle")
        }
    }
    
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: mode == .unlock ? "lock.shield.fill" : "shield.lefthalf.filled")
                .resizable()
                .scaledToFit()
                .frame(width: 45, height: 45)
                .foregroundColor(colors.primary)
                .padding(14)
                .background(Circle().fill(colors.primary.opacity(0.1)))
                .padding(.bottom, 4)
            
            Text(title)
                .font(.title2.bold())
                .foregroundColor(colors.foreground)
            
            Text(subtitle)
                .font(.footnote)
                .foregroundColor(colors.foreground.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 60)
        }
    }
}

private struct PINNumpadView: View {
    let mode: PINMode
    let onPress: (String) -> Void
    let onBackspace: () -> Void
    let onFaceID: () -> Void
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach([["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]], id: \.self) { row in
                HStack(spacing: 30) {
                    ForEach(row, id: \.self) { digit in
                        numberButton(digit)
                    }
                }
            }
            
            HStack(spacing: 30) {
                if case .unlock = mode, appEnv.security.isBiometricEnabled {
                    actionButton(icon: "faceid", action: onFaceID, accessibilityLabel: appEnv.language.localizedString("pin_accessibility_faceid"))
                } else {
                    Spacer().frame(width: 80)
                }
                
                numberButton("0")
                actionButton(icon: "delete.left.fill", action: onBackspace, accessibilityLabel: appEnv.language.localizedString("pin_accessibility_backspace"))
            }
        }
    }
    
    private func numberButton(_ digit: String) -> some View {
        Button(action: { onPress(digit) }) {
            Text(digit)
                .font(.system(size: 32, weight: .medium, design: .rounded))
                .foregroundColor(colors.foreground)
                .frame(width: 80, height: 80)
                .background(Circle().fill(colors.foreground.opacity(0.04)))
        }
        .accessibilityLabel(String(format: appEnv.language.localizedString("pin_accessibility_digit"), digit))
    }
    
    private func actionButton(icon: String, action: @escaping () -> Void, accessibilityLabel: String) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 26, weight: .medium))
                .foregroundColor(colors.foreground.opacity(0.85))
                .frame(width: 80, height: 80)
        }
        .accessibilityLabel(accessibilityLabel)
    }
}

private struct BackgroundVisuals: View {
    @Binding var animate: Bool
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            Circle()
                .fill(colors.primary.opacity(0.05))
                .frame(width: 450)
                .blur(radius: 100)
                .offset(x: animate ? -80 : 80, y: animate ? -200 : -100)
        }
        .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: animate)
    }
}

private struct PINIndicatorView: View {
    let pinCount: Int
    let maxDigits: Int
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(0..<maxDigits, id: \.self) { index in
                Circle()
                    .fill(index < pinCount ? colors.primary : colors.foreground.opacity(0.15))
                    .frame(width: 14, height: 14)
                    .scaleEffect(index < pinCount ? 1.2 : 1.0)
            }
        }
    }
}

struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: 10 * sin(animatableData * .pi * 3), y: 0))
    }
}
#Preview("Create PIN") {
    NavigationStack {
        PINView(mode: .create)
            .environment(AppRouter())
            .environment(AppState())
    }
}

#Preview("Unlock PIN") {
    NavigationStack {
        PINView(mode: .unlock)
            .environment(AppRouter())
            .environment(AppState())
    }
}
