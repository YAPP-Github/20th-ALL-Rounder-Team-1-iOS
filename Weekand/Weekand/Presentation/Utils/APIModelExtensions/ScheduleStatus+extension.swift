//
//  ScheduleStatus+extension.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/28.
//

import Foundation

extension ScheduleStatus {
    func toEntity() -> Status {
        switch self {
        case .completed:
            return Status.completed
        case .incompleted:
            return Status.upcoming
        case .skip:
            return Status.skipped
        case .undetermined:
            return Status.undetermined
        case .notYet:
            return Status.undetermined
        case .__unknown(let rawValue):
            return Status.completed
        }
    }
}
