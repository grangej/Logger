//
//  SumoLogger.swift
//  Logger
//
//  Created by Bikramjit Singh on 4/14/16.
//
//

import UIKit

open class SumoLogger: NSObject {
    
    open static let sharedLogger = SumoLogger()

    fileprivate var logTasks: [URLSessionDataTask] = [URLSessionDataTask]()
    
    override init() {
        
        super.init()
        
        guard let url = URL(string:"https://prod-idp-logging.lifelock.com/log?category=iOS") else {
            
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
        
        let aLogString : String = String.localizedStringWithFormat("data=%@", httpBody)
        guard let anEncodedLogString = aLogString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return
        }
                
        logRequest.httpBody = anEncodedLogString.data(using: String.Encoding.utf8)
        
        let logTask = URLSession.shared.dataTask(with: logRequest, completionHandler: { (data, response, error) in
            
            if let error = error {
                
                print("Error loging to sumlogic: \(error.localizedDescription)")
            }

        }) 
        
        self.logTasks.append(logTask)
        
        logTask.resume()

    }
}
