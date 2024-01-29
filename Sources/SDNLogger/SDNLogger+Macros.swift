//
//  Logger.swift
//  Logger
//
//  Created by John Grange on 10/17/17.
//

import Foundation
import Logging

@freestanding(expression)
public macro log(_ message: @autoclosure () -> Logger.Message,
                 level: Logger.Level,
                 metadata: @autoclosure () -> Logger.Metadata? = nil,
                 source: String? = nil,
                 category: LogCategory? = nil) = #externalMacro(module: "SDNLoggerMacros", type: "LogMacro")

@freestanding(expression)
public macro logTrace(_ message: @autoclosure () -> Logger.Message,
                      level: Logger.Level = .trace,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: String? = nil,
                      category: LogCategory? = nil) = #externalMacro(module: "SDNLoggerMacros", type: "TraceMacro")

@freestanding(expression)
public macro logDebug(_ message: @autoclosure () -> Logger.Message,
                      level: Logger.Level = .debug,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: String? = nil,
                      category: LogCategory? = nil) = #externalMacro(module: "SDNLoggerMacros", type: "DebugMacro")

@freestanding(expression)
public macro logInfo(_ message: @autoclosure () -> Logger.Message,
                     level: Logger.Level = .info,
                     metadata: @autoclosure () -> Logger.Metadata? = nil,
                     source: String? = nil,
                     category: LogCategory? = nil) = #externalMacro(module: "SDNLoggerMacros", type: "InfoMacro")

@freestanding(expression)
public macro logWarning(_ message: @autoclosure () -> Logger.Message,
                        level: Logger.Level = .warning,
                        metadata: @autoclosure () -> Logger.Metadata? = nil,
                        source: String? = nil,
                        category: LogCategory? = nil) = #externalMacro(module: "SDNLoggerMacros", type: "WarningMacro")

@freestanding(expression)
public macro logError(_ message: @autoclosure () -> Logger.Message,
                      level: Logger.Level = .error,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: String? = nil,
                      category: LogCategory? = nil) = #externalMacro(module: "SDNLoggerMacros", type: "ErrorMacro")

@freestanding(expression)
public macro logCritical(_ message: @autoclosure () -> Logger.Message,
                      level: Logger.Level = .critical,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: String? = nil,
                      category: LogCategory? = nil) = #externalMacro(module: "SDNLoggerMacros", type: "CriticalMacro")

@freestanding(expression)
public macro logError(_ error: Error,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: String? = nil,
                      category: LogCategory? = nil) = #externalMacro(module: "SDNLoggerMacros", type: "ErrorLogWithErrorMacro")

