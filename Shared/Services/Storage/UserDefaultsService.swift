//
//  UserDefaultsService.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public class UserDefaultsService {
    private let defaults = UserDefaults.standard
    
    public init() {}
    
    public func set<T>(_ value: T, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    public func get<T>(forKey key: String) -> T? {
        return defaults.object(forKey: key) as? T
    }
    
    public func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}
