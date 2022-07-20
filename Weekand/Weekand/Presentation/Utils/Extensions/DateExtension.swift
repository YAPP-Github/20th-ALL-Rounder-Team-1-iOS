//
//  Date+timeStamp.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/15.
//

import Foundation

extension Date {
    /// Date 값을 Timestamp로 변환
    func toTimestamp() -> Int64 {
        return Int64(self.timeIntervalSince1970*1000)
    }
    
    /// Date 값을 "HH:mm" 으로 변환
    func getTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: self)
    }
    
    /// Date 타입 두개를 "HH:mm - HH:mm"으로 변환
    static func getTimelineString(_ from: Date, _ to: Date) -> String {
        return "\(from.getTimeString()) - \(to.getTimeString())"
    }

}

extension Int64 {
    /// Timestamp값을 Date로 변환
    func toDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self/1000))
    }
}
