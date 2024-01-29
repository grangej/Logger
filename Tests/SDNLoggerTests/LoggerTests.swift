//
//  LoggerTests.swift
//
//
//  Created by John Grange on 11/12/23.
//

import XCTest
@testable import SDNLogger

final class LoggerTests: XCTestCase {
    
    func testFormedMessageWithMetaDataReturnsCorrectlyFormatedString() {
            
        
        var logger = LoggingOSLog(label: "com.test.logger")
        logger.metadata = ["testRootKey": .string("TestRootValue")]
        
        let formedMessage = logger.formedMessage(level: .info, 
                                                 message: "Testing",
                                                 metadata: ["testKey": .string("TestValue")],
                                                 source: "source",
                                                 file: "/test/test.swift",
                                                 function: "testFormedMessageWithMetaDataReturnsCorrectlyFormatedString", line: 19)
        
        XCTAssertEqual(formedMessage, "[ℹ️] Testing -- testRootKey=TestRootValue testKey=TestValue file=test.swift function=testFormedMessageWithMetaDataReturnsCorrectlyFormatedString line#=19")
        
    }
    
    enum TestError: Error {
        case test
    }
    
    func testLogMacro() {
        
        SDNLogger.bootstrap()
        #log("testing with metadata", level: .debug, metadata: ["Test": .string("test")], category: Category.api)
        #logCritical("testing")
        #logError(TestError.test)
    }

}
