//
//  Status.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/15.
//

import Foundation
import UIKit

/// 일정 상태 정보
enum Status: String {
    case upcoming = "UNCOMPLETED"
    case completed = "COMPLETED"
    case skipped = "SKIP"
    case undetermined = "UNDETERMINED"

    var icon: StatusIcon {
        switch self {
        case .upcoming:     return .upcoming
        case .completed:    return .completed
        case .skipped:      return .skipped
        case .undetermined: return .undetermined
        }
    }
    
}

/// 일정상태 아이콘 정보
enum StatusIcon: String {
    
    // TODO: Status 열거형 안으로 편입
    case upcoming = "state.upcomming"
    case proceeding = "state.proceeding"
    case completed = "state.completed"
    case skipped = "state.start"
    case undetermined = "state.hold"
    
    var tintColor: UIColor {
        switch self {
        case .upcoming:      return .gray600
        case .proceeding:    return .gray600
        case .completed:     return .mainColor
        case .skipped:       return .gray600
        case .undetermined:  return .gray300
        }
    }
}
