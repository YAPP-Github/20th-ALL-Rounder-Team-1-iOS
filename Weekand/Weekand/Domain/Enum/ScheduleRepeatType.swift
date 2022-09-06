//
//  ScheduleRepeatType.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/21.
//

import Foundation

enum ScheduleRepeatType {
    case daily
    case weekly
    case monthly
    case yearly
    case once
    
    var description: String {
        switch self {
        case .daily:
            return "매일"
        case .weekly:
            return "매주"
        case .monthly:
            return "매월"
        case .yearly:
            return "매년"
        case .once:
            return ""
        }
    }
}

extension ScheduleRepeatType {
    func toModel() -> RepeatType {
        switch self {
        case .daily:
            return RepeatType.daily
        case .weekly:
            return RepeatType.weekly
        case .monthly:
            return RepeatType.monthly
        case .yearly:
            return RepeatType.yearly
        case .once:
            return RepeatType.once
        }
    }
}
