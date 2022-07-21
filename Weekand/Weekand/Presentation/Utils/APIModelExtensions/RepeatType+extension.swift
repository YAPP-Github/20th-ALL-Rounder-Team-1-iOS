//
//  RepeatType+extension.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/21.
//

import Foundation

extension RepeatType {
    func toEntity() -> ScheduleRepeatType {
        switch self {
        case .daily:
            return ScheduleRepeatType.daily
        case .weekly:
            return ScheduleRepeatType.weekly
        case .monthly:
            return ScheduleRepeatType.monthly
        case .yearly:
            return ScheduleRepeatType.yearly
        case .once:
            return ScheduleRepeatType.once
        case .__unknown(let rawValue):
            return ScheduleRepeatType.once
        }
    }
}
