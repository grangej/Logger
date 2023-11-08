import Foundation
import Logging

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


