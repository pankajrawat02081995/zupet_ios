//
//  UIString.swift
//  Zupet
//
//  Created by Pankaj Rawat on 30/08/25.
//

import Foundation

extension String {
    /// Convert UTC/ETC datetime string to local 12-hour format
    func toLocalTime(
        inputFormat: DateFormatType,
        outputFormat: DateFormatType
    ) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC") // server time (ETC/UTC)
        
        // Parse server date
        formatter.dateFormat = inputFormat.rawValue
        guard let date = formatter.date(from: self) else { return self }
        
        // Convert to local
        formatter.timeZone = .current
        formatter.dateFormat = outputFormat.rawValue
        return formatter.string(from: date)
    }
    
    func shortAge(fromFormat format: String = "yyyy-MM-dd") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let dob = dateFormatter.date(from: self) else {
            return nil
        }
        
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: dob, to: now)
        
        if let years = components.year, years >= 1 {
            return "\(years) yrs"
        } else if let months = components.month {
            return "\(months) m"
        }
        
        return nil
    }
    
    func isWithinTwoHours() -> Bool {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = formatter.date(from: self) else {
            return false
        }
        
        let now = Date() // current local time
        let twoHoursLater = now.addingTimeInterval(2 * 60 * 60) // +2 hours
        
        // Check if cremation time is >= now AND <= 2 hours later
        return date >= now && date <= twoHoursLater
    }
}
