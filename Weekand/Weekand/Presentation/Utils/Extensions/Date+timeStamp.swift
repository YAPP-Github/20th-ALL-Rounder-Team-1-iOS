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
