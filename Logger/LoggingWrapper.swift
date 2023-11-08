//
//  LoggingWrapper.swift
//
//
//  Created by John Grange on 11/8/23.
//

import Foundation
import Logging
import os.log

public protocol LoggerOutput {

    /// Log a message to the output, logger output can use addtional category and type if desired
    ///
    /// - Parameters:
    ///   - object: Any - The object to log, should be string describable
    ///   - functionName: Functiona name that log happened
    ///   - fileName:Filename that the log happened
    ///   - lineNumber:The line number the log happened
    ///   - category:Category of the log
    ///   - logType: The type of log, debug , error, critical, default
    /// - Throws: An error if the logging failed
    // swiftlint:disable:next function_parameter_count
    func log(object: Any,
             functionName: String,
             fileName: String,
             lineNumber: Int,
             category: LogCategory,
             logType: OSLogType) throws
}

public class LoggingWrapper: LogHandler {
    
    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set {
            self.metadata[metadataKey] = newValue
        }
    }
    
    public var metadata: Logging.Logger.Metadata = .init()
    
    public var logLevel: Logging.Logger.Level = .info
        
    private var output: LoggerOutput
    
    public init(_ output: LoggerOutput) {
        self.output = output
    }
    
    public func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
                
        try? output.log(object: message, functionName: function, fileName: file, lineNumber: Int(line), category: Category.custom(categoryName: source), logType: OSLogType.from(loggerLevel: level))
    }
}

public protocol LoggerFormat {

    func format(object: Any, functionName: String, fileName: String, lineNumber: Int) -> String
}

public enum LogFormat: LoggerFormat {

    case `default`
    case verbose
    case custom(formatter: LoggerFormat)

    public func format(object: Any, functionName: String, fileName: String, lineNumber: Int) -> String {

        switch self {

        case .default:
            return "\(object)"
        case .custom(formatter: let formatter):
            return formatter.format(object: object,
                                    functionName: functionName,
                                    fileName: fileName,
                                    lineNumber: lineNumber)
        case .verbose:
            let className = (fileName as NSString).lastPathComponent
            let finalMessage = "<\(className)> \(functionName) [#\(lineNumber)]| \(object)\n"
            return finalMessage
        }
    }
}
