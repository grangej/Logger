//
//  Logger.swift
//  Logger
//
//  Created by John Grange on 1/1/15.
//  Copyright (c) 2015 Y Media Labs. All rights reserved.
//

import Foundation


public enum Logger: Int {


    static var currentLevel: Logger = .logLevelInfo

    case logLevelCritical, logLevelError, logLevelWarn, logLevelInfo, logLevelVerbose
    
    
    /// Log the given message depending on the curret log level
    public func log(let logMessage: String, logPrefix: String?) -> Bool {
        switch self {
        case .logLevelCritical:
            logWithMessage("Fatal: \(logMessage)", logPrefix: logPrefix)
            return true
        case .logLevelError:
            if Logger.currentLevel == .logLevelCritical {
                return false
            }
            logWithMessage("Error: \(logMessage)", logPrefix: logPrefix)
            return true
        case .logLevelWarn:
            if Logger.currentLevel == .logLevelCritical ||
                Logger.currentLevel == .logLevelError {
                    return false
            }
            logWithMessage("Warm: \(logMessage)", logPrefix: logPrefix)
            return true
        case .logLevelInfo:
            if Logger.currentLevel == .logLevelCritical ||
                Logger.currentLevel == .logLevelError ||
                Logger.currentLevel == .logLevelWarn {
                    return false
            }
            logWithMessage("Info: \(logMessage)", logPrefix: logPrefix)
            return true
        default:
            if Logger.currentLevel == .logLevelCritical ||
                Logger.currentLevel == .logLevelError ||
                Logger.currentLevel == .logLevelWarn ||
                Logger.currentLevel == .logLevelInfo{
                    return false
            }
            logWithMessage("Verbose: \(logMessage)", logPrefix: logPrefix)
            return true
        }
    }
    
    internal func logWithMessage(logMessage : String!, logPrefix: String?) {
        
        if let prefixMsg = logPrefix {
            
            println("\(prefixMsg)-\(logMessage)")
        }
        else {
            
            println("\(logMessage)")
        }
    }

}