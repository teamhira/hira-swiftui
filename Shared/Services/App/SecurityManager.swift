//
//  SecurityManager.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI
import Observation
import LocalAuthentication

@MainActor
@Observable
final class SecurityManager {
    // MARK: - State
    var isPINSet: Bool {
        didSet { UserDefaults.standard.set(isPINSet, forKey: pinSetKey) }
    }
    
    var isBiometricEnabled: Bool {
        didSet { UserDefaults.standard.set(isBiometricEnabled, forKey: biometricKey) }
    }
    
    var storedPIN: String? {
        didSet { UserDefaults.standard.set(storedPIN, forKey: pinStorageKey) }
    }
    
    // MARK: - Local Keys
    private let pinSetKey = "security_pin_active"
    private let biometricKey = "security_biometric_active"
    private let pinStorageKey = "security_pin_payload"
    
    init() {
        self.isPINSet = UserDefaults.standard.bool(forKey: "security_pin_active")
        self.isBiometricEnabled = UserDefaults.standard.bool(forKey: "security_biometric_active")
        self.storedPIN = UserDefaults.standard.string(forKey: "security_pin_payload")
    }
    
    func resetSecurity() {
        isPINSet = false
        isBiometricEnabled = false
        storedPIN = nil
    }
}
