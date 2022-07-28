//
//  WRepeatTextManager.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/27.
//

import Foundation

struct WRepeatTextManager {
    
    static func combineTimeDate(repeatType: ScheduleRepeatType, repeatSelectedValue: [ScheduleWeek]?, repeatEndDate: Date?) -> String {
        var repeatText = ""
        
        if repeatType == .once {
            return repeatText
        }
        
        if let repeatSelectedValue = repeatSelectedValue {
            let repeatSelectedValueText = repeatSelectedValue.map { $0.description }.joined(separator: ",")
            if let date = repeatEndDate {
                let dateString = WDateFormatter.dateFormatter.string(from: date)
                repeatText = "\(dateString)까지 \(repeatType.description) \(repeatSelectedValueText)"
            } else {
                repeatText = "\(repeatType.description) \(repeatSelectedValueText)"
            }
        } else {
            if let date = repeatEndDate {
                let dateString = WDateFormatter.dateFormatter.string(from: date)
                repeatText = "\(dateString)까지 \(repeatType.description)"
            } else {
                repeatText = "\(repeatType.description)"
            }
        }
        return repeatText + " 반복"
    }
}
