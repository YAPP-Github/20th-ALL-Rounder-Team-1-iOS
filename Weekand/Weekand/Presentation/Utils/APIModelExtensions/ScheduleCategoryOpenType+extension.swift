//
//  Sche.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/15.
//

import Foundation

extension ScheduleCategoryOpenType {
    func toEntity() -> CategoryOpenType {
        switch self {
        case .allOpen:
            return CategoryOpenType.allOpen
        case .followerOpen:
            return CategoryOpenType.followerOpen
        case .closed:
            return CategoryOpenType.closed
        case .__unknown(_):
            return CategoryOpenType.closed
        }
    }
    
}
