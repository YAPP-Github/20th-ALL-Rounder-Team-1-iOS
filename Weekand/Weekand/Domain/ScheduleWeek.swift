//
//  ScheduleWeek.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/22.
//

import Foundation

enum ScheduleWeek {
    case sunday, monday, thuesday, wednesday, thursday, friday, saturday
    
    var description: String {
        switch self {
        case .sunday:
            return "일"
        case .monday:
            return "월"
        case .thuesday:
            return "화"
        case .wednesday:
            return "수"
        case .thursday:
            return "목"
        case .friday:
            return "금"
        case .saturday:
            return "토"
        }
    }
}
