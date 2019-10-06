//
//  OSLogLogger.swift
//  Logger
//
//  Created by John Grange on 2019/07/26.
//

import Foundation
import os.log

public class OSLogLogger: LoggerOutput {

    private let osLogQueue = DispatchQueue(label: "osLog.accessor")

    private var loggers: [String: OSLog] = [String: OSLog]()

    public init() {

    }
    private func osLog(_ category: LogCategory) -> OSLog {

        var logger: OSLog!

        osLogQueue.sync {

            if let existingLogger = self.loggers[category.categoryKey] {

                logger = existingLogger
            } else {

                logger = OSLog(subsystem: Logger.logSubSystem, category: category.categoryKey)
                self.loggers[category.categoryKey] = logger
            }
        }

        return logger
    }
// swiftlint:disable:next function_parameter_count
    public func log(object: Any,
                    functionName: String,
                    fileName: String,
                    lineNumber: Int,
                    category: LogCategory,
                    logType: OSLogType) throws {

        let message = LogFormat.verbose.format(object: object,
                                               functionName: functionName,
                                               fileName: fileName,
                                               lineNumber: lineNumber)

        let logger = osLog(category)

        #if DEBUG
        os_log("%{public}s", log: logger, type: logType, message)
        #else
        os_log("%@", log: logger, type: logType, message)
        #endif
    }
}
