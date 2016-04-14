//
//  SumoLogger.swift
//  Logger
//
//  Created by Bikramjit Singh on 4/14/16.
//
//

import UIKit

class SumoLogger: NSObject {
    
    class var sharedLogger: SumoLogger {
        struct Singleton {
            static let instance = SumoLogger()
        }
        return Singleton.instance
    }
    
    private var logRequest: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL.init(string:"https://dev-idp-logging.aws.lifelock.ad:8443/log?category=iOS")!)
    private var logQueue : NSOperationQueue = NSOperationQueue()
    
    
    func stopLogging() {
        self.logQueue.cancelAllOperations()
    }
    
    
    func logMessage(httpBody:String) {
        self.logRequest.HTTPMethod = "POST"
        self.logRequest.timeoutInterval = 60
        self.logRequest.HTTPShouldHandleCookies = true

        if !httpBody.isEmpty {
            let aBodyData = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
            self.logRequest.HTTPBody = aBodyData
            NSURLConnection.sendAsynchronousRequest(self.logRequest, queue:self.logQueue, completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                
            })
        }
    }
}
