//
//  OpenType.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/15.
//

import Foundation

enum CategoryOpenType: String {
    case allOpen = "allOpen"
    case followerOpen = "followerOpen"
    case closed = "closed"
    
    var description: String {
        switch self {
        case .allOpen:
            return "모두 공개"
        case .followerOpen:
            return "친구 공개"
        case .closed:
            return "비공개"
        }
    }
}
