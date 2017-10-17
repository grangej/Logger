//
//  SuplexLogger.swift
//  Logger
//
//  Created by Bikramjit Singh on 12/21/16.
//
//

import UIKit

open class SuplexLogger: NSObject {
    
    open static let sharedLogger = SuplexLogger()
    
    fileprivate var logTasks: [URLSessionDataTask] = [URLSessionDataTask]()
    
    override init() {
        
        super.init()
        
        guard let url = URL(string:"http://sample-env.kbpvdkezpy.us-west-2.elasticbeanstalk.com/log") else {
            
            return
        }
        
        self.logRequest = URLRequest(url: url)
        
        self.logRequest?.httpMethod = "POST"
        self.logRequest?.timeoutInterval = 60
        self.logRequest?.httpShouldHandleCookies = true
    }
    
    fileprivate var logRequest: URLRequest?
    fileprivate var logQueue : OperationQueue = OperationQueue()
    
    
    func stopLogging() {
        self.logQueue.cancelAllOperations()
    }
    
    
    func logMessage(_ httpBody:String) {
        
        guard var logRequest = self.logRequest else {
            
            return
        }
        
        guard let anEncodedLogString = httpBody.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return
        }
        
        logRequest.httpBody = anEncodedLogString.data(using: String.Encoding.utf8)
        
        let logTask = URLSession.shared.dataTask(with: logRequest) { (data, response, error) in
            
            if let error = error {
                
                print("Error loging To Suplex: \(error.localizedDescription)")
            }
        }
        
        self.logTasks.append(logTask)
        
        logTask.resume()
        
    }
}
