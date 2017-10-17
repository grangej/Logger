//
//  ErrorProtocal.swift
//  memberapp
//
//  Created by John Grange on 7/17/15.
//  Copyright © 2015 LifeLock. All rights reserved.
//

import Foundation



public protocol ErrorProtocal {

    var errorDomain : String { get }
    
    var errorCode : Int { get }

    func errorForCode() -> NSError
    
}

extension ErrorProtocal {
    
    public func errorForCode() -> NSError {
        
        let userInfo: [AnyHashable: Any]
        
        switch self {
            
        default:
            
            if let error = self as? CustomDebugStringConvertible {
                
                userInfo = [NSLocalizedDescriptionKey: error.debugDescription]

            }
            else {
                
                userInfo = [NSLocalizedDescriptionKey: "Invalid Error Type"]
            }
        }
        
        return NSError(domain: self.errorDomain, code: self.errorCode, userInfo: userInfo)
        
        
    }
    
}
