//
//  AppState.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Observation

@Observable
public class AppState {
    public var isFirstLaunch: Bool {
        get { !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") }
        set { UserDefaults.standard.set(!newValue, forKey: "hasCompletedOnboarding") }
    }
    
    public var isLoggedIn: Bool = false
    public var currentUser: UserInfo? = nil
    public var isLoading: Bool = false
    public var showSplash: Bool = true
    
    public init() {}
}
