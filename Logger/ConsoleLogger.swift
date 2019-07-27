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
