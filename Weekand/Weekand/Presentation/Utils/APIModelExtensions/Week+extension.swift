//
//  Week+extension.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/28.
//

import Foundation

extension Week {
    func toEntity() -> ScheduleWeek {
        switch self {
        case .monday:
            return ScheduleWeek.monday
        case .tuesday:
            return ScheduleWeek.tuesday
        case .wednesday:
            return ScheduleWeek.wednesday
        case .thursday:
            return ScheduleWeek.thursday
        case .friday:
            return ScheduleWeek.friday
        case .saturday:
            return ScheduleWeek.saturday
        case .sunday:
            return ScheduleWeek.sunday
        case .__unknown(let rawValue):
            return ScheduleWeek.monday
        }
    }
}
