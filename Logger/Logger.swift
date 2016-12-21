//
//  Logger.swift
//  Logger
//
//  Created by John Grange on 1/1/15.
//  Copyright (c) 2015 SD Networks All rights reserved.
//

import Foundation

public typealias ResultError = protocol<ErrorType, CustomDebugStringConvertible, CustomStringConvertible, ErrorProtocal>


public extension ErrorType {
    
    func logError() {
        
        self.log(Logger.logLevelError)
    }
    
    func logWarning() {
        
        self.log(Logger.logLevelWarn)

    }
    
    func logInfo() {
        
        self.log(Logger.logLevelInfo)
        
    }
    
    func log(logLevel: Logger) {
        
        if let resultError = self as? ErrorProtocal,
            let debugError = self as? CustomDebugStringConvertible
        {
            
            logLevel.log(debugError.debugDescription, logPrefix: resultError.errorDomain)
            
        }
        else {
            
            let error = self as NSError
            
            logLevel.log(error.localizedDescription, logPrefix: error.domain)
        }
    }
}

public enum Logger: Int {

    public static var sumoLogicEnabled: Bool = true

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

    case logLevelCritical, logLevelError, logLevelWarn, logLevelInfo, logLevelVerbose, logLevelSuplex
    
    
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
        case .logLevelSuplex:
            if Logger.currentLevel == .logLevelCritical ||
                Logger.currentLevel == .logLevelError ||
                Logger.currentLevel == .logLevelWarn || Logger.currentLevel == .logLevelInfo {
                return false
            }
            logWithMessage("Verbose: \(logMessage)", logPrefix: logPrefix)
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
        
        let truncatedMessage = logMessage.trunc(200, trailing: "...")

        
        if let prefixMsg = logPrefix {
            
            finalMessage = "\(prefixMsg)-\(truncatedMessage)"
        }
        else {
            
            finalMessage = "\(truncatedMessage)"
        }
        
        switch self {
            
        case .logLevelError, .logLevelCritical:
            
            CrashlyticsRecorder.sharedInstance?.recordError(truncatedMessage, domain: logPrefix ?? "com.lifelock.Logger")
            
            fallthrough
            
        default:
            
            if let encodedString = finalMessage.stringByRemovingPercentEncoding {
                
                CrashlyticsRecorder.sharedInstance?.log(encodedString)

            }
            
            if Logger.sumoLogicEnabled {
                
                SumoLogger.sharedLogger.logMessage(finalMessage)

            }
            
            //print(finalMessage)
            
            SuplexLogger.sharedLogger.logMessage(finalMessage)
            
            
        }
    }
    
    

}

extension String {
    func trunc(length: Int, trailing: String? = "...") -> String {
        if self.characters.count > length {
            return self.substringToIndex(self.startIndex.advancedBy(length)) + (trailing ?? "")
        } else {
            return self
        }
    }
}
