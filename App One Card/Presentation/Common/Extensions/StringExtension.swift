//
//  StringExtension.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import Foundation
import UIKit

extension String {
    var asUrl: URL? {
        return URL(string: self)
    }
    
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    func validateString(withRegex regex: Regex) -> Bool {
        do {
            let expression = try NSRegularExpression(pattern: regex.rawValue, options: .caseInsensitive)
            let matches = expression.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            return matches.count > 0
        } catch {
            return false
        }
    }

    func maskPhoneNumber(lastVisibleDigitsCount: Int) -> String {
        let visibleDigitsCount = min(max(lastVisibleDigitsCount, 0), self.count)
        let startIndex = self.index(self.endIndex, offsetBy: -visibleDigitsCount)
        let maskedString = self.enumerated().map { index, char in
            if index < startIndex.encodedOffset {
                return "*"
            } else {
                return String(char)
            }
        }
        return maskedString.joined()
    }
    
    func maskEmailFirstCharacters() -> String {
        let startIndex = self.index(self.startIndex, offsetBy: 4, limitedBy: self.endIndex) ?? self.startIndex
        let maskedEmail = String(repeating: "*", count: self.distance(from: self.startIndex, to: startIndex)) + self[startIndex...]
        return maskedEmail
    }
    
    func convertStringToDecimalAndFormat(sign: String) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // You can set the desired locale here
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        if let number = formatter.number(from: self) {
            return "S/ \(sign == "-" ? "-" : "")" + (formatter.string(from: number) ?? self)
        }
        
        return "S/ \(sign == "-" ? "-" : "")" + self

    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

enum Regex: String{
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    case containUpperCaseLetter = ".*[A-Z].*"
    case containNumber = ".*[0-9]+.*"
    case containSpecialCharacter = ".*[!&^%$#@()/]+.*"
    case decimal = "^\\d*\\.?\\d*$"
    case contain8numbers = "^\\d{8}$"
    case contain9numbers = "^\\d{9}$"
    case contain9to12numbers = "^\\d{9,12}$"
    case contain9to12characters = "^.{9,12}$"
    case contain11numbers = "^\\d{11}$"
    case name = "^[\\p{L}ñÑáéíóúÁÉÍÓÚüÜ\\s'-]+$"
    case alphanumeric = "^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]+$"
    case containLettersAndNumbers = "^(?=.*[a-zA-Z])(?=.*\\d).+$"
    case startsWith9 = "^9"
    case passwordContainSpecialCharacters = ".*[!@#$%^&*].*"
}
