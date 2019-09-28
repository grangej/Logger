//
//  Logger.swift
//  Logger
//
//  Created by John Grange on 10/17/17.
//

import Foundation
import os.log

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

public typealias FlushCompletionBlock = () -> Void

public protocol BatchLoggerOutput {

    /// Add support for flushing a queue in a batched logger output
    ///
    /// - Parameters:
    ///   - completed: Completion block to be called when flush is complete for all outputs
    func flush(completion: FlushCompletionBlock?)
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

    Logger.defaultLogger.log(object: object,
                             functionName: functionName,
                             fileName: fileName,
                             lineNumber: lineNumber,
                             category: category,
                             logType: logType)

}

public func sdn_log(error: Error,
                      functionName: String = #function,
                      fileName: String = #file,
                      lineNumber: Int = #line,
                      category: LogCategory = Category.defaultCategory,
                      rawJSON: String? = nil) {

    let errorDescription: String
    var category = category

    do {
        throw error
    } catch DecodingError.dataCorrupted(let context) {

        category = .decoder
        errorDescription = "\(context.debugDescription) forPath: \(context.codingPath)"

    } catch DecodingError.keyNotFound(let key, let context) {

        errorDescription = "\(key.stringValue) was not found, \(context.debugDescription) forPath: \(context.codingPath)"
        category = .decoder

    } catch DecodingError.typeMismatch(let type, let context) {

        errorDescription = "\(type) was expected, \(context.debugDescription) forPath: \(context.codingPath)"
        category = .decoder

    } catch DecodingError.valueNotFound(let type, let context) {

        errorDescription = "No value was found for \(type), \(context.debugDescription) forPath: \(context.codingPath)"
        category = .decoder

    } catch let error {

        errorDescription = error.localizedDescription
    }

        Logger.defaultLogger.log(object: errorDescription,
                             functionName: functionName,
                             fileName: fileName,
                             lineNumber: lineNumber,
                             category: category,
                             logType: .error)
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

open class Logger {

    private var outputs: [LoggerOutput] = [LoggerOutput]()

    public static var logSubSystem = "net.sd-networks.Logger"
    public static var _defaultLogger: Logger = Logger()

    open class var defaultLogger: Logger {

        return self._defaultLogger
    }

    private var flushGroup = DispatchGroup()

    convenience public init() {

        let consoleOutput = ConsoleLogger()

        self.init(outputs: [consoleOutput])
    }

    public init(outputs: [LoggerOutput]) {

        self.outputs = outputs
    }

    public func add(output: LoggerOutput) {

        self.outputs.append(output)
    }

    public func flush(completion: FlushCompletionBlock? = nil) {

        let flushGroup = self.flushGroup
        for output in self.outputs {

            if let batchOutput = output as? BatchLoggerOutput {

                flushGroup.enter()

                batchOutput.flush(completion: {

                    flushGroup.leave()
                })
            }
        }

        flushGroup.notify(queue: DispatchQueue.main) {

            completion?()
        }
    }

    @discardableResult
    public func log(object: Any,
                    functionName: String = #function,
                    fileName: String = #file,
                    lineNumber: Int = #line,
                    category: LogCategory = Category.defaultCategory,
                    logType: OSLogType = .debug) -> Bool {

        var allOutputsSuccessful = true
        for output in self.outputs {

            do {

                try output.log(object: object,
                               functionName: functionName,
                               fileName: fileName,
                               lineNumber: lineNumber,
                               category: category,
                               logType: logType)

            } catch let error {

                #if DEBUG

                let className = String(describing: type(of: output))
                print("Output: \(className) failed: \(error.localizedDescription)")

                #endif

                allOutputsSuccessful = false
            }
        }

        return allOutputsSuccessful
    }
}
