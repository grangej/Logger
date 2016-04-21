//
//  SumoLogger.swift
//  Logger
//
//  Created by Bikramjit Singh on 4/14/16.
//
//

import UIKit

public class SumoLogger: NSObject {
    
    public static let sharedLogger = SumoLogger()

    override init() {
        
        super.init()
        
        guard let url = NSURL(string:"http://dev-idp-logging.aws.lifelock.ad:8080/log?category=iOS") else {
            
            return
        }
        
        self.logRequest = NSMutableURLRequest(URL: url)
    }
    
    private var logRequest: NSMutableURLRequest?
    private var logQueue : NSOperationQueue = NSOperationQueue()
    
    
    func stopLogging() {
        self.logQueue.cancelAllOperations()
    }
    
    
    func logMessage(httpBody:String) {
        
        guard let logRequest = self.logRequest else {
            
            return
        }
        logRequest.HTTPMethod = "POST"
        logRequest.timeoutInterval = 60
        logRequest.HTTPShouldHandleCookies = true

        if !httpBody.isEmpty {
            let aBodyData = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
            logRequest.HTTPBody = aBodyData
            NSURLConnection.sendAsynchronousRequest(logRequest, queue:self.logQueue, completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                
            })
        }
    }
}
