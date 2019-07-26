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
    ///   - message: The text of the message
    ///   - category:Category oof the log
    ///   - logType: The type of log, debug , error, critical, default
    /// - Throws: An error if the logging failed
    func log(message: String, category: LogCategory, logType: OSLogType) throws
}

public typealias FlushCompletionBlock = () -> Void

public protocol BatchLoggerOutput {

    /// Add support for flushing a queue in a batched logger output
    ///
    /// - Parameters:
    ///   - completed: Completion block to be called when flush is complete for all outputs
    func flush(completion: FlushCompletionBlock?)
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

    public func log(object: Any,
                   functionName: String = #function,
                   fileName: String = #file,
                   lineNumber: Int = #line,
                   category: LogCategory = Category.defaultCategory,
                   logType: OSLogType = .debug) {


        let className = (fileName as NSString).lastPathComponent
        let finalMessage = "<\(className)> \(functionName) [#\(lineNumber)]| \(object)\n"

        for output in self.outputs {

            do {

                try output.log(message: finalMessage, category: category, logType: logType)
            } catch let error {

                #if DEBUG

                let className = String(describing: type(of: output))
                print("Output: \(className) failed: \(error.localizedDescription)")

                #endif
            }
        }
    }
}
