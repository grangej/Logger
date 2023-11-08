//
//  OSLogLogger.swift
//  Logger
//
//  Created by John Grange on 2019/07/26.
//

import Foundation
import Logging
import os

extension Logger.Level {

    var color: String {
        switch self {
        case .trace: return "💜"
        case .debug: return "💚"
        case .info: return "ℹ️"
        case .notice: return "💙"
        case .warning: return "⚠️"
        case .error: return "⛔️"
        case .critical: return "🛑"
        }
    }
}

struct LoggingOSLog: LogHandler {
    var logLevel: Logger.Level = .info
    let label: String
    private static var loggers: [String: OSLog] = [String: OSLog]()

    private static let osLogQueue = DispatchQueue(label: "osLog.accessor")

    private static func osLog(subsystem: String, category: String) -> OSLog {

        var logger: OSLog!

        osLogQueue.sync {

            if let existingLogger = self.loggers[category] {

                logger = existingLogger
            } else {

                logger = OSLog(subsystem: subsystem, category: category)
                self.loggers[category] = logger
            }
        }

        return logger
    }

    init(label: String) {
        self.label = label
    }

    func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {

        let logger = Self.osLog(subsystem: label, category: source)

        var combinedPrettyMetadata = self.prettyMetadata
        if let metadataOverride = metadata, !metadataOverride.isEmpty {
            combinedPrettyMetadata = self.prettify(
                self.metadata.merging(metadataOverride) {
                    return $1
                }
            )
        }

        var formedMessage = "[\(level.color)] \(message.description)"

        if combinedPrettyMetadata != nil {
            formedMessage += " -- " + combinedPrettyMetadata!
        }
        #if DEBUG
        os_log("%{public}@", log: logger, type: OSLogType.from(loggerLevel: level), formedMessage as NSString)
        #else
        os_log("%@", log: logger, type: OSLogType.from(loggerLevel: level), formedMessage as NSString)
        #endif
    }

    private var prettyMetadata: String?
    var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(self.metadata)
        }
    }

    /// Add, remove, or change the logging metadata.
    /// - parameters:
    ///    - metadataKey: the key for the metadata item.
    subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set {
            self.metadata[metadataKey] = newValue
        }
    }

    private func prettify(_ metadata: Logger.Metadata) -> String? {
        if metadata.isEmpty {
            return nil
        }
        return metadata.map {
            "\($0)=\($1)"
        }.joined(separator: " ")
    }
}

extension OSLogType {
    static func from(loggerLevel: Logger.Level) -> Self {
        switch loggerLevel {
        case .trace:
            /// `OSLog` doesn't have `trace`, so use `debug`
            return .debug
        case .debug:
            return .debug
        case .info:
            return .info
        case .notice:
            /// `OSLog` doesn't have `notice`, so use `info`
            return .info
        case .warning:
            /// `OSLog` doesn't have `warning`, so use `info`
            return .info
        case .error:
            return .error
        case .critical:
            return .fault
        }
    }
}

extension Logger.Level {
    init(osLogType: OSLogType) {
        switch osLogType {
        case .info:
            self = .info
        case .debug:
            self = .debug
        case .error:
            self = .error
        case .fault:
            self = .critical
        default:
            self = .trace
        }
    }
}

