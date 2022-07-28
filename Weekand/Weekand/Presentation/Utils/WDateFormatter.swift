//
//  DateFormatter.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/26.
//

import Foundation

struct WDateFormatter {
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd."
        formatter.locale = Locale(identifier: "Ko_KR")
        return formatter
    }
    
    static var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "Ko_KR")
        return formatter
    }
    
    static func combineDate(date: Date, time: Date) -> Date {
        let dateString = dateFormatter.string(from: date)
        let timeString = timeFormatter.string(from: time)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd.HH:mm"
        guard let convertDate = formatter.date(from: dateString + timeString) else {
            return Date()
        }
        
        return convertDate
    }
    
    static func combineTimeDate(startTime: Date, endTime: Date) -> String {
        let startTimeString = timeFormatter.string(from: startTime)
        let endTimeString = timeFormatter.string(from: endTime)
        
        return "\(startTimeString) - \(endTimeString)"
    }
}
