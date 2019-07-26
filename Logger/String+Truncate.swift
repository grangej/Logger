//
//  String+Truncate.swift
//  Logger
//
//  Created by John Grange on 10/17/17.
//

import Foundation

extension String {
    func trunc(_ length: Int, trailing: String? = "...") -> String {
        if self.count > length {
            let upperBound = self.index(self.startIndex, offsetBy: length)
            return String(self[..<upperBound]) + (trailing ?? "")
        } else {
            return self
        }
    }
}

