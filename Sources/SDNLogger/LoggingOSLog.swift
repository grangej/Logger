//
//  OSLogLogger.swift
//  Logger
//
//  Created by John Grange on 2019/07/26.
//

import Foundation
import Logging
import os
import OrderedCollections

public typealias Logger = Logging.Logger

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

public struct LoggingOSLog: LogHandler {
    public var logLevel: Logger.Level = .info
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

    public init(label: String) {
        self.label = label
    }

    public func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {

        let logger = Self.osLog(subsystem: label, category: source)

        let formedMessage = formedMessage(level: level, message: message, metadata: metadata, source: source, file: file, function: function, line: line)
        
        #if DEBUG
        os_log("%{public}@", log: logger, type: OSLogType.from(loggerLevel: level), formedMessage as NSString)
        #else
        os_log("%@", log: logger, type: OSLogType.from(loggerLevel: level), formedMessage as NSString)
        #endif
    }
    
    func formedMessage(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) -> String {
        
        let className = (file as NSString).lastPathComponent
        let fileMetadata: OrderedDictionary<String, Logger.MetadataValue> = ["file": .string(className), "function": .string(function), "line#": .string("\(line)")]
        
        
        var combinedMetadata = self.sortedMetadata
        if let metadataOverride = metadata, !metadataOverride.isEmpty {
            combinedMetadata.merge(metadataOverride, uniquingKeysWith: { _, newKey in newKey })
        }
        
        combinedMetadata.merge(fileMetadata, uniquingKeysWith: { original, fileKey in
            return original
        })
        
        combinedMetadata.merge(fileMetadata, uniquingKeysWith: { original, _ in original })
        
        let prettyMetadata = self.prettify(combinedMetadata)

        var formedMessage = "[\(level.color)] \(message.description)"

        if let prettyMetadata = prettyMetadata {
            formedMessage += " -- " + prettyMetadata
        }
        
        return formedMessage
    }
    
    private var sortedMetadata: OrderedDictionary<String, Logger.MetadataValue> = OrderedDictionary()
    
    public var metadata: Logger.Metadata {
        get {
            return Dictionary(uniqueKeysWithValues: self.sortedMetadata.map { ($0.key, $0.value) })
        }
        set {
            self.sortedMetadata = OrderedDictionary(uniqueKeysWithValues: newValue.sorted { $0.key < $1.key })
        }
    }

    /// Add, remove, or change the logging metadata.
    /// - parameters:
    ///    - metadataKey: the key for the metadata item.
    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set {
            self.metadata[metadataKey] = newValue
        }
    }

    private func prettify(_ metadata: OrderedDictionary<String, Logger.MetadataValue>) -> String? {
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

