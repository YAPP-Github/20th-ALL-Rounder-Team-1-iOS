//
//  CompleteStatus.swift
//  Weekand
//
//  Created by 이호영 on 2022/08/01.
//

import Foundation

enum CompleteStatus {
    case complete, incomplete
    
    var description: String {
        switch self {
        case .complete:
            return "완료"
        case .incomplete:
            return "미완료"
        }
    }
}
