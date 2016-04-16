//
//  Logger.swift
//  Logger
//
//  Created by John Grange on 1/1/15.
//  Copyright (c) 2015 SD Networks All rights reserved.
//

import Foundation

public extension ErrorType {
    
    func logError() {
        
        if let resultError = self as? ErrorProtocal,
            let debugError = self as? CustomDebugStringConvertible
        {
            
            Logger.logLevelError.log(debugError.debugDescription, logPrefix: resultError.errorDomain)
            
        }
        else {
            
            let error = self as NSError
            
            Logger.logLevelError.log(error.localizedDescription, logPrefix: error.domain)
        }
    }
}

public enum Logger: Int {


    public static var currentLevel: Logger = .logLevelWarn {
        
        didSet {
            
            print("Set level to: \(currentLevel)")
        }
    }
    public static var userIdentifier: String = "No Identifier Set" {
        
        didSet {
            
            CrashlyticsRecorder.sharedInstance?.setUserIdentifier(userIdentifier)
        }
    }
    public static var userEmail: String = "No Email Set" {
        
        didSet {
            
            CrashlyticsRecorder.sharedInstance?.setUserEmail(userEmail)
        }
    }
    public static var userName: String = " No Name Set" {
        
        didSet {
            
            CrashlyticsRecorder.sharedInstance?.setUserName(userName)
        }
    }

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
            logWithMessage("Warn: \(logMessage)", logPrefix: logPrefix)
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
    
    internal func logWithMessage(logMessage : String, logPrefix: String?, errorCode: Int? = 0) {
        
        let finalMessage: String
        
        if let prefixMsg = logPrefix {
            
            finalMessage = "\(prefixMsg)-\(logMessage)"
        }
        else {
            
            finalMessage = "\(logMessage)"
        }
        
        switch self {
            
        case .logLevelError, .logLevelCritical:
            
            CrashlyticsRecorder.sharedInstance?.recordError(logMessage, domain: logPrefix ?? "com.lifelock.Logger")
            
            fallthrough
            
        default:
            SumoLogger.sharedLogger.logMessage(finalMessage)
            
            CrashlyticsRecorder.sharedInstance?.log(finalMessage)
            
            print(finalMessage)
        }
    }
    
    

}