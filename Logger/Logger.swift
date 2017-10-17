//
//  Logger.swift
//  Logger
//
//  Created by John Grange on 10/17/17.
//

import Foundation

public protocol LoggerOutput {

    /// Log a message to the output, with an optional prefix msg
    ///
    /// - Parameters:
    ///   - message: The text of the message
    ///   - prefix: The optional prefix
    /// - Throws: An error if the logging failed
    func log(message: String, prefix: String?) throws
}

public typealias FlushCompletionBlock = () -> ()

public protocol BatchLoggerOutput {


    /// Add support for flushing a queue in a batched logger output
    ///
    /// - Parameters:
    ///   - completed: Completion block to be called when flush is complete for all outputs
    func flush(completion: FlushCompletionBlock?)
}

class Logger {

    private var outputs: [LoggerOutput] = [LoggerOutput]()

    public static var defaultLogger: Logger = Logger()

    public static var currentLevel: Logger.Level = .warning {

        didSet {

            print("Set level to: \(currentLevel)")
        }
    }

    private var flushGroup = DispatchGroup()

    init() {

        let consoleOutput = ConsoleLogger()
        self.outputs = [consoleOutput]
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

    public func log(message: String, logPrefix: String? = nil, level: Level = .verbose) -> Bool {

        guard level.shouldLog else {

            return false
        }

        var messageLogged = false

        let finalMessage = "\(level.prefix): \(message)"

        for output in self.outputs {

            do {

                try output.log(message: finalMessage, prefix: logPrefix)
                messageLogged = true
            }
            catch let error {

                #if DEBUG

                let className = String(describing: type(of: output))
                print("Output: \(className) failed: \(error.localizedDescription)")
                    
                #endif
            }
        }

        return messageLogged
    }

    public func logCritical(message: String, logPrefix: String? = nil) -> Bool {

        return self.log(message: message, logPrefix: logPrefix, level: .critical)
    }

    public func logError(message: String, logPrefix: String? = nil) -> Bool {

        return self.log(message: message, logPrefix: logPrefix, level: .error)
    }

    public func logWarning(message: String, logPrefix: String? = nil) -> Bool {

        return self.log(message: message, logPrefix: logPrefix, level: .warning)
    }

    public func logInfo(message: String, logPrefix: String? = nil) -> Bool {

        return self.log(message: message, logPrefix: logPrefix, level: .info)
    }

    public func logVerbose(message: String, logPrefix: String? = nil) -> Bool {

        return self.log(message: message, logPrefix: logPrefix, level: .verbose)
    }

    public enum Level: Int {

        case critical = 4, error = 3, warning = 2, info = 1, verbose = 0

        internal var shouldLog: Bool {

            return Logger.currentLevel.rawValue <= self.rawValue
        }

        internal var prefix: String {

            switch self {

            case .critical:
                return "Critical"
            case .error:
                return "Error"
            case .warning:
                return "Warning"
            case .info:
                return "Info"
            case .verbose:
                return "Verbose"
            }
        }
    }
}
