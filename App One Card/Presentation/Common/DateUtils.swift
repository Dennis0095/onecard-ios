//
//  DateUtils.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import Foundation

class DateUtils {
    
    static let shared = DateUtils()
    
    private let formatter = DateFormatter()
    
    func getFormattedDate(date: Date, outputFormat: String) -> String {
        formatter.dateFormat = outputFormat
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    
    func parseDate(string: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
    
    func parseDateToString(string: String, format: String, outputFormat: String) -> String {
        if let parseDate = parseDate(string: string, format: format) {
            return getFormattedDate(date: parseDate, outputFormat: outputFormat)
        } else {
            return ""
        }
    }
}
