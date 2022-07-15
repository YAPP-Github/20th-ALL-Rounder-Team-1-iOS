//
//  Date+timeStamp.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/15.
//

import Foundation

extension Date {
    func toStringTimestamp() -> String {
        return String(self.timeIntervalSince1970)
    }
}

extension String {
    func fromStringTimestamp() -> Date {
        
        return Date(timeIntervalSince1970: Double(self)!)
    }
}
