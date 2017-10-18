//
//  String+Truncate.swift
//  Logger
//
//  Created by John Grange on 10/17/17.
//

import Foundation

extension String {
    func trunc(_ length: Int, trailing: String? = "...") -> String {
        if self.characters.count > length {
            return self.substring(to: self.characters.index(self.startIndex, offsetBy: length)) + (trailing ?? "")
        } else {
            return self
        }
    }
}
