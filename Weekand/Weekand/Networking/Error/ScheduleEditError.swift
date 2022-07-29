//
//  ScheduleEditError.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/29.
//

import Foundation

enum ScheduleEditError {
    case startEndTimeEqually
    
    var serverDescription: String? {
        switch self {
        case .startEndTimeEqually:
            return "시작 일시와 종료 일시를 확인해주세요."
        }
    }
}
