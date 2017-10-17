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
    fileprivate var logRequest: URLRequest?
    fileprivate var logTasks: [URLSessionDataTask] = [URLSessionDataTask]()
    fileprivate var batchLimit: Int = 10
    fileprivate var logs : [[String : AnyObject]]?
    
    func setupLogging(url: String) {
        guard let url = URL(string:url) else {
            return
        }
        
        self.logRequest = URLRequest(url: url)
        self.logRequest?.httpMethod = "POST"
        self.logRequest?.timeoutInterval = 60
        self.logRequest?.httpShouldHandleCookies = true
        self.logs = nil
    }
    
    func stopLogging() {
        self.logTasks.removeAll()
    }
    
    func log(message: AnyObject) {
        let logMessage = ["message" : message]
        self.logs?.append(logMessage)
        self.uploadMessage()
    }
    
    private func uploadMessage() {
        guard var logRequest = self.logRequest, let messagesToUpload = self.logs, messagesToUpload.count < self.batchLimit else {
            return
        }
        
        do {
            let body : Data = try JSONSerialization.data(withJSONObject: messagesToUpload, options: JSONSerialization.WritingOptions.prettyPrinted)
            logRequest.httpBody = body
            
            let logTask = URLSession.shared.dataTask(with: logRequest, completionHandler: { (data, response, error) in
                
                self.logs?.removeAll()
                
                if let error = error {
                    print("Error loging to sumlogic: \(error.localizedDescription)")
                }
            })
            self.logTasks.append(logTask)
            logTask.resume()
        } catch let anError {
            anError.logError()
        }
    }
}
