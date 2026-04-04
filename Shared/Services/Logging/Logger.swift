//
//  Logger.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import os.log

public class Logger {
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.hira.app", category: "General")
    
    public init() {}
    
    public func debug(_ message: String) {
        os_log("%{public}@", log: log, type: .debug, message)
    }
    
    public func info(_ message: String) {
        os_log("%{public}@", log: log, type: .info, message)
    }
    
    public func error(_ message: String) {
        os_log("%{public}@", log: log, type: .error, message)
    }
}
