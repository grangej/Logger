//
//  Logger+Default.swift
//
//
//  Created by John Grange on 11/8/23.
//

import Foundation

extension Logger {
    public init() {
        self.init(label: SDNLogger.subsystem)
    }
}
