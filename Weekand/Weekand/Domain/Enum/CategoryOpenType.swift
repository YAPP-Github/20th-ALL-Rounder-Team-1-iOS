//
//  OpenType.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/15.
//

import Foundation

enum CategoryOpenType: String {
    case allOpen
    case followerOpen
    case closed
    
    var description: String {
        switch self {
        case .allOpen:
            return "전체 공개"
        case .followerOpen:
            return "친구 공개"
        case .closed:
            return "비공개"
        }
    }
}

extension CategoryOpenType {
    static var openTypeList: [CategoryOpenType] {
        return [.allOpen, .followerOpen, .closed]
    }
    
    var listIndex: Int {
        switch self {
        case .allOpen:
            return 0
        case .followerOpen:
            return 1
        case .closed:
            return 2
        }
    }
}

extension CategoryOpenType {
    func toModel() -> ScheduleCategoryOpenType {
        switch self {
        case .allOpen:
            return ScheduleCategoryOpenType.allOpen
        case .followerOpen:
            return ScheduleCategoryOpenType.followerOpen
        case .closed:
            return ScheduleCategoryOpenType.closed
        }
    }
}
