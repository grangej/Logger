//
//  SDNLogger.swift
//
//
//  Created by John Grange on 11/8/23.
//

import Foundation
import Logging

public typealias LogHandlerFactory = (String) -> LogHandler

public enum SDNLogger {
    
    static var subsystem: String = "net.sd-networks.Logger"
    private static var logLevel: Logger.Level = .trace
    
    public static func bootstrap(subsystem: String = "net.sd-networks.Logger", 
                                 logLevel: Logger.Level = .trace,
                                 factory: LogHandlerFactory? = nil) {
        
        let factory = factory ?? defaultFactory
        Self.subsystem = subsystem
        Self.logLevel = logLevel
        
        LoggingSystem.bootstrap(factory)
    }
    
    private static var defaultFactory: LogHandlerFactory = { label in
            var osLog = LoggingOSLog(label: label)
            osLog.logLevel = Self.logLevel
            return MultiplexLogHandler([osLog])
        }
}
