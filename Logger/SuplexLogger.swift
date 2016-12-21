//
//  SuplexLogger.swift
//  Logger
//
//  Created by Bikramjit Singh on 12/21/16.
//
//

import UIKit

public class SuplexLogger: NSObject {
    
    public static let sharedLogger = SuplexLogger()
    
    private var logTasks: [NSURLSessionDataTask] = [NSURLSessionDataTask]()
    
    override init() {
        
        super.init()
        
        guard let url = NSURL(string:"http://ec2-54-202-253-78.us-west-2.compute.amazonaws.com/log") else {
            
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
        
        logRequest.HTTPBody = anEncodedLogString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let logTask = NSURLSession.sharedSession().dataTaskWithRequest(logRequest) { (data, response, error) in
            
            if let error = error {
                
                print("Error loging : \(error.localizedDescription)")
            }
            
        }
        
        self.logTasks.append(logTask)
        
        logTask.resume()
        
    }
}
