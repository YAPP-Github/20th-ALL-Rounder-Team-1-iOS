//
//  Date+timeStamp.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/15.
//

import Foundation

extension Date {
    func toStringTimestamp() -> String {
        return String(Int(self.timeIntervalSince1970*1000))
    }
}

extension String {
    func fromStringTimestamp() -> Date {
        
        return Date(timeIntervalSince1970: Double(self)!/1000.0)
    }
}
