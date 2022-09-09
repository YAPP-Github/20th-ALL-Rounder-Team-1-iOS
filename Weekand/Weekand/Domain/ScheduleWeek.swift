//
//  ScheduleWeek.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/22.
//

import Foundation

enum ScheduleWeek: CaseIterable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    var description: String {
        switch self {
        case .sunday:
            return "일"
        case .monday:
            return "월"
        case .tuesday:
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

extension ScheduleWeek {
    func toModel() -> Week {
        switch self {
        case .sunday:
            return Week.sunday
        case .monday:
            return Week.monday
        case .tuesday:
            return Week.tuesday
        case .wednesday:
            return Week.wednesday
        case .thursday:
            return Week.thursday
        case .friday:
            return Week.friday
        case .saturday:
            return Week.saturday
        }
    }
}
