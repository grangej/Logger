import Foundation
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

extension Logging.Logger {
    
    @inlinable
    public func error(_ message: @autoclosure () -> Logger.Message,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: String?,
                      category: LogCategory?,
                      file: String = #fileID,
                      function: String = #function,
                      line: UInt = #line) {
        
        let source = category?.categoryKey ?? source
        
        self.error(message(), metadata: metadata(), source: source, file: file, function: function, line: line)
    }
    
    @inlinable
    public func trace(_ message: @autoclosure () -> Logger.Message,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: String?,
                      category: LogCategory?,
                      file: String = #fileID,
                      function: String = #function,
                      line: UInt = #line) {
        
        let source = category?.categoryKey ?? source
        
        self.trace(message(), metadata: metadata(), source: source, file: file, function: function, line: line)
    }
    
    @inlinable
    public func debug(_ message: @autoclosure () -> Logger.Message,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: String?,
                      category: LogCategory?,
                      file: String = #fileID,
                      function: String = #function,
                      line: UInt = #line) {
        
        let source = category?.categoryKey ?? source
        
        self.debug(message(), metadata: metadata(), source: source, file: file, function: function, line: line)
    }
    
    @inlinable
    public func info(_ message: @autoclosure () -> Logger.Message,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: String?,
                      category: LogCategory?,
                      file: String = #fileID,
                      function: String = #function,
                      line: UInt = #line) {
        
        let source = category?.categoryKey ?? source
        
        self.info(message(), metadata: metadata(), source: source, file: file, function: function, line: line)
    }
    
    
    @inlinable
    public func notice(_ message: @autoclosure () -> Logger.Message,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: String?,
                      category: LogCategory?,
                      file: String = #fileID,
                      function: String = #function,
                      line: UInt = #line) {
        
        let source = category?.categoryKey ?? source
        
        self.notice(message(), metadata: metadata(), source: source, file: file, function: function, line: line)
    }
    
    @inlinable
    public func warning(_ message: @autoclosure () -> Logger.Message,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: String?,
                      category: LogCategory?,
                      file: String = #fileID,
                      function: String = #function,
                      line: UInt = #line) {
        
        let source = category?.categoryKey ?? source
        
        self.warning(message(), metadata: metadata(), source: source, file: file, function: function, line: line)
    }
    
    @inlinable
    public func critical(_ message: @autoclosure () -> Logger.Message,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: String?,
                      category: LogCategory?,
                      file: String = #fileID,
                      function: String = #function,
                      line: UInt = #line) {
        
        let source = category?.categoryKey ?? source
        
        self.critical(message(), metadata: metadata(), source: source, file: file, function: function, line: line)
    }

}


