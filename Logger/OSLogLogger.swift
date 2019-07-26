//
//  OSLogLogger.swift
//  Logger
//
//  Created by John Grange on 2019/07/26.
//

import Foundation
import os.log

public struct OSLogLogger: LoggerOutput {

    private static let osLogQueue = DispatchQueue(label: "osLog.accessor")

    private var loggers: [String: OSLog] = [String: OSLog]()

    private mutating func osLog(_ category: LogCategory) -> OSLog {

        var logger: OSLog!

        OSLogLogger.osLogQueue.sync {

            if let existingLogger = self.loggers[category.categoryKey] {

                logger = existingLogger
            } else {

                logger = OSLog(subsystem: Logger.logSubSystem, category: category.categoryKey)
                self.loggers[category.categoryKey] = logger
            }
        }

        return logger
    }

    public func log(message: String, category: LogCategory, logType: OSLogType) throws {

    }

}
