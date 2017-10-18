//
//  ConsoleLogger.swift
//  Logger
//
//  Created by John Grange on 10/17/17.
//

import Foundation

enum ConsoleLoggerError: LocalizedError {

    case ProductionLoggingIsDisabled

    var errorDescription: String? {

        return "Production Logging is disabled, run in debug mode"
    }
}

struct ConsoleLogger: LoggerOutput {

    private let productionLoggingIsDisabled: Bool

    init(productionLoggingIsDisabled: Bool = true) {

        self.productionLoggingIsDisabled = productionLoggingIsDisabled
    }

    func log(message: String, prefix: String?) throws {

        #if !DEBUG

            if self.productionLoggingIsDisabled {

                throw ConsoleLoggerError.ProductionLoggingIsDisabled
            }

        #endif

        let finalMessage: String
        let truncatedMessage = message.trunc(200, trailing: "...")


        if let prefixMsg = prefix {

            finalMessage = "\(prefixMsg)-\(truncatedMessage)"
        }
        else {

            finalMessage = "\(truncatedMessage)"
        }

        print(finalMessage)
    }
}
