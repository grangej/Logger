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
        
        guard let url = NSURL(string:"https://prod-idp-logging.lifelock.com/log?category=iOS") else {
            
            return
        }
        
        self.logRequest = NSMutableURLRequest(URL: url)
        self.logRequest?.HTTPMethod = "POST"
        self.logRequest?.timeoutInterval = 60
        self.logRequest?.HTTPShouldHandleCookies = true
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
        
        let aLogString : String = String.localizedStringWithFormat("data=%@", httpBody)
        guard let anEncodedLogString = aLogString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
            return
        }
        
        if !httpBody.isEmpty {
            let aBodyData = anEncodedLogString.dataUsingEncoding(NSUTF8StringEncoding)
            logRequest.HTTPBody = aBodyData
            NSURLConnection.sendAsynchronousRequest(logRequest, queue:self.logQueue, completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                
            })
        }
    }
}
