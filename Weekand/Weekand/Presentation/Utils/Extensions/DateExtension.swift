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
}

extension Int64 {
    /// Timestamp값을 Date로 변환
    func toDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self/1000))
    }
}
