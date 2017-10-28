//
//  ConsoleLogger.swift
//  Logger
//
//  Created by John Grange on 10/17/17.
//

import Foundation

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

    public func log(message: String, prefix: String?) throws {

        #if !DEBUG

            if self.productionLoggingIsDisabled {

                throw ConsoleLoggerError.ProductionLoggingIsDisabled
            }

        #endif

        let finalMessage: String
        let truncatedMessage = message.trunc(200, trailing: "...")

        if let prefixMsg = prefix {

            finalMessage = "\(prefixMsg)-\(truncatedMessage)"
        } else {

            finalMessage = "\(truncatedMessage)"
        }

        print(finalMessage)
    }
}
