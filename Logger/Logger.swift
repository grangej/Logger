//
//  Logger.swift
//  Logger
//
//  Created by John Grange on 1/1/15.
//  Copyright (c) 2015 SD Networks All rights reserved.
//

import Foundation

public typealias ResultError = Error & CustomDebugStringConvertible & CustomStringConvertible & ErrorProtocal


public extension Error {
    
    func logError() {
        
        self.log(Logger.logLevelError)
    }
    
    func logWarning() {
        
        self.log(Logger.logLevelWarn)

    }
    
    func logInfo() {
        
        self.log(Logger.logLevelInfo)
        
    }
    
    func log(_ logLevel: Logger) {
        
        if let resultError = self as? ErrorProtocal,
            let debugError = self as? CustomDebugStringConvertible
        {
            
            _ = logLevel.log(debugError.debugDescription, logPrefix: resultError.errorDomain)
            
        }
        else {
            
            let error = self as NSError
            
            _ = logLevel.log(error.localizedDescription, logPrefix: error.domain)
        }
    }
}

public enum Logger: Int {

    public static var production: Bool = true
    
    public static var sumoLogicEnabled: Bool = true
    
    public static var suplexLoggingEnabled: Bool = true

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
    @discardableResult public func log(_ logMessage: String, logPrefix: String?) -> Bool {
        switch self {
        case .logLevelSuplex:
            logWithMessage("Suplex: \(logMessage)", logPrefix: logPrefix)
            return true
        case .logLevelCritical:
            
            switch Logger.currentLevel {
                
            case .logLevelCritical, .logLevelSuplex:
                return false
            default:
                logWithMessage("Critical: \(logMessage)", logPrefix: logPrefix)
                return true
            }
            
        case .logLevelError:
            
            switch Logger.currentLevel {
                
            case .logLevelCritical, .logLevelSuplex:
                return false
            default:
                logWithMessage("Error: \(logMessage)", logPrefix: logPrefix)
                return true
            }

        case .logLevelWarn:
            
            switch Logger.currentLevel {
                
            case .logLevelCritical, .logLevelError, .logLevelSuplex:
                return false
            default:
                logWithMessage("Warn: \(logMessage)", logPrefix: logPrefix)
                return true
            }

        case .logLevelInfo:
            
            switch Logger.currentLevel {
                
            case .logLevelCritical, .logLevelError, .logLevelWarn, .logLevelSuplex:
                return false
            default:
                logWithMessage("Info: \(logMessage)", logPrefix: logPrefix)
                return true
            }


        default:
            
            switch Logger.currentLevel {
                
            case .logLevelCritical, .logLevelError, .logLevelWarn, .logLevelInfo, .logLevelSuplex:
                return false
            default:
                logWithMessage("Verbose: \(logMessage)", logPrefix: logPrefix)
                return true
            }

        }
    }
    
    
    internal func logWithMessage(_ logMessage : String, logPrefix: String?, errorCode: Int? = 0) {
        
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
        
        case .logLevelSuplex:
            
            if Logger.suplexLoggingEnabled {
                
                SuplexLogger.sharedLogger.logMessage(finalMessage)
            }

            fallthrough
            
        default:
            
            if let encodedString = finalMessage.removingPercentEncoding {
                
                CrashlyticsRecorder.sharedInstance?.log(encodedString)

            }
            
            if Logger.sumoLogicEnabled && !Logger.production {
                
                SumoLogger.sharedLogger.log(message: finalMessage as AnyObject)

            }
            
            if !Logger.production {
                
                print(finalMessage)

            }
            
            
        }
    }
    
    

}

extension String {
    func trunc(_ length: Int, trailing: String? = "...") -> String {
        if self.characters.count > length {
            return self.substring(to: self.characters.index(self.startIndex, offsetBy: length)) + (trailing ?? "")
        } else {
            return self
        }
    }
}
