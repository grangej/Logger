//
//  ConsoleLogger.swift
//  Logger
//
//  Created by John Grange on 10/17/17.
//

import Foundation
import os.log

public enum ConsoleLoggerError: LocalizedError {

    case productionLoggingIsDisabled

    public var errorDescription: String? {

        return "Production Logging is disabled, run in debug mode"
    }
}

public struct ConsoleLogger: LoggerOutput {

    private let productionLoggingIsDisabled: Bool

    public init(productionLoggingIsDisabled: Bool = true) {

        self.productionLoggingIsDisabled = productionLoggingIsDisabled
    }

    public func log(message: String, category: Category, logType: OSLogType) throws {

        #if !DEBUG

            if self.productionLoggingIsDisabled {

                throw ConsoleLoggerError.productionLoggingIsDisabled
            }

        #endif

        let finalMessage: String
        let truncatedMessage = message.trunc(200, trailing: "...")

        finalMessage = "\(truncatedMessage)"    

        print(finalMessage)
    }
}
