//
//  Logger+Error.swift
//
//
//  Created by John Grange on 11/8/23.
//

import Foundation
import Logging

extension Logger {
    
    public func error(error: Error,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: String? = nil,
                      category: LogCategory? = nil,
                      file: String = #fileID,
                      function: String = #function,
                      line: UInt = #line) {
        
        
        let errorDescription: String
        var category = category

        do {
            throw error
        } catch DecodingError.dataCorrupted(let context) {

            category = Category.decoder
            errorDescription = "\(context.debugDescription) forPath: \(context.codingPath)"

        } catch DecodingError.keyNotFound(let key, let context) {

            errorDescription = "\(key.stringValue) was not found, \(context.debugDescription) forPath: \(context.codingPath)"
            category = Category.decoder

        } catch DecodingError.typeMismatch(let type, let context) {

            errorDescription = "\(type) was expected, \(context.debugDescription) forPath: \(context.codingPath)"
            category = Category.decoder

        } catch DecodingError.valueNotFound(let type, let context) {

            errorDescription = "No value was found for \(type), \(context.debugDescription) forPath: \(context.codingPath)"
            category = Category.decoder

        } catch let error as NSError {
            errorDescription = error.description
        }
        
        self.error("\(errorDescription)", metadata: metadata(), source: source, category: category, file: file, function: function, line: line)
    }
}
