//
//  LoggerTests.swift
//  LoggerTests
//
//  Created by John Grange on 1/1/15.
//  Copyright (c) 2015 SD Networks All rights reserved.
//

import UIKit
import XCTest
@testable import Logger


class LoggerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCriticalLogLevel() {
        
        Logger.currentLevel = Logger.logLevelCritical
        
        XCTAssertTrue(Logger.logLevelCritical.log("critical", logPrefix: "Test"), "Critical logs should be shown")
        XCTAssertFalse(Logger.logLevelError.log("error", logPrefix: "Test"), "Error logs should not be shown")
        XCTAssertFalse(Logger.logLevelWarn.log("warn", logPrefix: "Test"), "Warning logs should not be shown")
        XCTAssertFalse(Logger.logLevelInfo.log("info", logPrefix: "Test"), "Info logs should not be shown")
        XCTAssertFalse(Logger.logLevelVerbose.log("verbose", logPrefix: "Test"), "Verbose logs should not be shown")
        
        
    }
    
    func testErrorLogLevel() {
        
        Logger.currentLevel = Logger.logLevelError
        
        XCTAssertTrue(Logger.logLevelCritical.log("critical", logPrefix: "Test"), "Critical logs should be shown")
        XCTAssertTrue(Logger.logLevelError.log("error", logPrefix: "Test"), "Error logs should be shown")
        XCTAssertFalse(Logger.logLevelWarn.log("warn", logPrefix: "Test"), "Warning logs should not be shown")
        XCTAssertFalse(Logger.logLevelInfo.log("info", logPrefix: "Test"), "Info logs should not be shown")
        XCTAssertFalse(Logger.logLevelVerbose.log("verbose", logPrefix: "Test"), "Verbose logs should not be shown")
        
        
    }
    
    func testWarningLogLevel() {
        
        Logger.currentLevel = Logger.logLevelWarn
        
        XCTAssertTrue(Logger.logLevelCritical.log("critical", logPrefix: "Test"), "Critical logs should be shown")
        XCTAssertTrue(Logger.logLevelError.log("error", logPrefix: "Test"), "Error logs should be shown")
        XCTAssertTrue(Logger.logLevelWarn.log("warn", logPrefix: "Test"), "Warning logs should be shown")
        XCTAssertFalse(Logger.logLevelInfo.log("info", logPrefix: "Test"), "Info logs should not be shown")
        XCTAssertFalse(Logger.logLevelVerbose.log("verbose", logPrefix: "Test"), "Verbose logs should not be shown")
        
        
    }
    
    func testInfoLogLevel() {
        
        Logger.currentLevel = Logger.logLevelInfo
        
        XCTAssertTrue(Logger.logLevelCritical.log("critical", logPrefix: "Test"), "Critical logs should be shown")
        XCTAssertTrue(Logger.logLevelError.log("error", logPrefix: "Test"), "Error logs should be shown")
        XCTAssertTrue(Logger.logLevelWarn.log("warn", logPrefix: "Test"), "Warning logs should be shown")
        XCTAssertTrue(Logger.logLevelInfo.log("info", logPrefix: "Test"), "Info logs should be shown")
        XCTAssertFalse(Logger.logLevelVerbose.log("verbose", logPrefix: "Test"), "Verbose logs should not be shown")
        
        
    }
    
    func testVerboseLogLevel() {
        
        Logger.currentLevel = Logger.logLevelVerbose
        
        XCTAssertTrue(Logger.logLevelCritical.log("critical", logPrefix: "Test"), "Critical logs should be shown")
        XCTAssertTrue(Logger.logLevelError.log("error", logPrefix: "Test"), "Error logs should be shown")
        XCTAssertTrue(Logger.logLevelWarn.log("warn", logPrefix: "Test"), "Warning logs should be shown")
        XCTAssertTrue(Logger.logLevelInfo.log("info", logPrefix: "Test"), "Info logs should be shown")
        XCTAssertTrue(Logger.logLevelVerbose.log("verbose", logPrefix: "Test"), "Verbose logs should be shown")
        
        
    }
    
    
    func testCrashCrashlytics() {
        
        Logger.currentLevel = Logger.logLevelVerbose
        
        Logger.logLevelInfo.log("https://www.walmart.com/account/login?returnUrl=%2Faccount%2F", logPrefix: "com.lifelock.testapp")
    }
    
    func testLogResultError() {
        
        Logger.currentLevel = Logger.logLevelVerbose

        TestError.Test.logInfo()
    }
    
}

enum TestError: ErrorType {
    
    case Test
}
