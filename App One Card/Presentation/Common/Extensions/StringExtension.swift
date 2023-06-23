//
//  StringExtension.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import Foundation

extension String {
    var asUrl: URL? {
        return URL(string: self)
    }
    
    func validateString(withRegex regex: Regex) -> Bool {
        do {
            let expression = try NSRegularExpression(pattern: regex.rawValue, options: .caseInsensitive)
            let matches = expression.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            return matches.count > 0
        } catch {
            print("Invalid regular expression: \(error)")
            return false
        }
    }
}

enum Regex: String{
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    case containUpperCaseLetter = ".*[A-Z].*"
    case containNumber = ".*[0-9]+.*"
    case containSpecialCharacter = ".*[!&^%$#@()/]+.*"
    case decimal = "^\\d*\\.?\\d*$"
    case contain8numbers = "^\\d{8}$"
    case contain11numbers = "^\\d{11}$"
}
