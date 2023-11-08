//
//  Logger.swift
//  Logger
//
//  Created by John Grange on 10/17/17.
//

import Foundation
import os.log
import Logging

public protocol LogCategory {

    var categoryKey: String { get }
}

public enum Category: LogCategory {

    case defaultCategory
    case network
    case notification
    case database
    case api
    case analytics
    case login
    case decoder
    case conversation
    case profile
    case people
    case threadLock
    case custom(categoryName: String)

    public var categoryKey: String {

        switch self {

        case .analytics: return "analytics"
        case .defaultCategory: return "default"
        case .notification: return "notification"
        case .network: return "network"
        case .database: return "database"
        case .api: return "api"
        case .decoder: return "decoder"
        case .login: return "login"
        case .conversation: return "conversation"
        case .profile: return "profile"
        case .people: return "people"
        case .threadLock: return "threadLock"
        case .custom(categoryName: let categoryName):
            return categoryName
        }
    }
}

/// Helper function to Log to Logger.defaultLogger
/// - Parameter object: Object we are trying to log, should be string describable
/// - Parameter category: category of the log, must comply with LogCategory (defaults to Logger.Category.defaultCategory)
/// - Parameter logType: OSLogType of the log (defaults to .debug)
public func sdn_log(object: Any,
                    functionName: String = #function,
                    fileName: String = #file,
                    lineNumber: Int = #line,
                    category: LogCategory = Category.defaultCategory,
                    logType: OSLogType = .debug) {
    
    Logger().log(level: Logger.Level(osLogType: logType), Logger.Message(stringLiteral: "\(object)"), source: category.categoryKey, file: fileName, function: functionName, line: UInt(lineNumber))
}

public func sdn_log(error: Error,
                      functionName: String = #function,
                      fileName: String = #file,
                      lineNumber: Int = #line,
                      category: LogCategory = Category.defaultCategory,
                      rawJSON: String? = nil) {
    
    var metadata: [String: Logger.Metadata.Value] = [:]
    
    if let rawJSON = rawJSON {
        metadata["rawJSON"] = .string(rawJSON)
    }
    
    Logger().error(error: error, metadata: metadata, source: nil, category: category, file: fileName, function: functionName, line: UInt(lineNumber))
}

public typealias Logger = Logging.Logger
