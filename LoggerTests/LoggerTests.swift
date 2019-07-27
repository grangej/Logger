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

        Logger._defaultLogger = logger
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
