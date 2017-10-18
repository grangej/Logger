//
//  LoggerTests.swift
//  LoggerTests
//
//  Created by John Grange on 1/1/15.
//  Copyright (c) 2015 SD Networks All rights reserved.
//

import UIKit
import XCTest
import Logger


class LoggerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        let consoleOutput = ConsoleLogger(productionLoggingIsDisabled: false)

        let logger = Logger(outputs: [consoleOutput])

        Logger.defaultLogger = logger
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCriticalLogLevel() {
        
        Logger.currentLevel = Logger.Level.critical

        XCTAssertTrue(Logger.defaultLogger.logCritical(message: "critical", logPrefix: "Test"), "Critical logs should be shown")
        XCTAssertFalse(Logger.defaultLogger.logError(message: "error", logPrefix: "Test"), "error logs should be shown")
        XCTAssertFalse(Logger.defaultLogger.logWarning(message: "warning", logPrefix: "Test"), "warning logs should be shown")
        XCTAssertFalse(Logger.defaultLogger.logInfo(message: "info", logPrefix: "Test"), "info logs should be shown")
        XCTAssertFalse(Logger.defaultLogger.logVerbose(message: "verbose", logPrefix: "Test"), "verbose logs should be shown")
    }
    
    func testErrorLogLevel() {
        
        Logger.currentLevel = Logger.Level.error

        XCTAssertTrue(Logger.defaultLogger.logCritical(message: "critical", logPrefix: "Test"), "Critical logs should be shown")
        XCTAssertTrue(Logger.defaultLogger.logError(message: "error", logPrefix: "Test"), "error logs should be shown")
        XCTAssertFalse(Logger.defaultLogger.logWarning(message: "warning", logPrefix: "Test"), "warning logs should be shown")
        XCTAssertFalse(Logger.defaultLogger.logInfo(message: "info", logPrefix: "Test"), "info logs should be shown")
        XCTAssertFalse(Logger.defaultLogger.logVerbose(message: "verbose", logPrefix: "Test"), "verbose logs should be shown")
    }
    
    func testWarningLogLevel() {
        
        Logger.currentLevel = Logger.Level.warning

        XCTAssertTrue(Logger.defaultLogger.logCritical(message: "critical", logPrefix: "Test"), "Critical logs should be shown")
        XCTAssertTrue(Logger.defaultLogger.logError(message: "error", logPrefix: "Test"), "error logs should be shown")
        XCTAssertTrue(Logger.defaultLogger.logWarning(message: "warning", logPrefix: "Test"), "warning logs should be shown")
        XCTAssertFalse(Logger.defaultLogger.logInfo(message: "info", logPrefix: "Test"), "info logs should be shown")
        XCTAssertFalse(Logger.defaultLogger.logVerbose(message: "verbose", logPrefix: "Test"), "verbose logs should be shown")

        
    }
    
    func testInfoLogLevel() {
        
        Logger.currentLevel = Logger.Level.info

        XCTAssertTrue(Logger.defaultLogger.logCritical(message: "critical", logPrefix: "Test"), "Critical logs should be shown")
        XCTAssertTrue(Logger.defaultLogger.logError(message: "error", logPrefix: "Test"), "error logs should be shown")
        XCTAssertTrue(Logger.defaultLogger.logWarning(message: "warning", logPrefix: "Test"), "warning logs should be shown")
        XCTAssertTrue(Logger.defaultLogger.logInfo(message: "info", logPrefix: "Test"), "info logs should be shown")
        XCTAssertFalse(Logger.defaultLogger.logVerbose(message: "verbose", logPrefix: "Test"), "verbose logs should be shown")

        
    }
    
    func testVerboseLogLevel() {
        
        Logger.currentLevel = Logger.Level.verbose

        XCTAssertTrue(Logger.defaultLogger.logCritical(message: "critical", logPrefix: "Test"), "Critical logs should be shown")
        XCTAssertTrue(Logger.defaultLogger.logError(message: "error", logPrefix: "Test"), "error logs should be shown")
        XCTAssertTrue(Logger.defaultLogger.logWarning(message: "warning", logPrefix: "Test"), "warning logs should be shown")
        XCTAssertTrue(Logger.defaultLogger.logInfo(message: "info", logPrefix: "Test"), "info logs should be shown")
        XCTAssertTrue(Logger.defaultLogger.logVerbose(message: "verbose", logPrefix: "Test"), "verbose logs should be shown")

        
    }

}

