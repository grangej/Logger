//
//  LoggerProductionTests.swift
//  LoggerProductionTests
//
//  Created by John Grange on 10/18/17.
//

import XCTest
import Logger

class LoggerProductionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConsoleDisabledInProduction() {

        let logger = Logger()

        XCTAssertFalse(logger.logCritical(message: "Testing"), "Logging to console should fail here")
    }

    func testConsoleEnabledInProduction() {

        let output = ConsoleLogger(productionLoggingIsDisabled: false)

        let logger = Logger(outputs: [output])

        XCTAssertTrue(logger.logCritical(message: "Testing"), "Logging to console should be successful here")
    }
}
