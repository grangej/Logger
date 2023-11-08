//
//  SDNLogger.swift
//
//
//  Created by John Grange on 11/8/23.
//

import Foundation
import Logging

enum SDNLogger {
    
    static var subsystem: String = "net.sd-networks.Logger"
    
    public static func bootstrap(subsystem: String = "net.sd-networks.Logger", logLevel: Logger.Level = .trace) {
        Self.subsystem = subsystem
        
        LoggingSystem.bootstrap { label in
            var osLog = LoggingOSLog(label: label)
            osLog.logLevel = logLevel
            return MultiplexLogHandler([osLog])
        }
    }
}
