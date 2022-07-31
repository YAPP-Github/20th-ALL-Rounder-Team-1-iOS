//
//  FollowInformationType.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/31.
//

import Foundation

enum FollowInformationType {
    case followee
    case follower
    
    var descriptionSuffix: String {
        switch self {
        case .followee: return "님이 팔로우하는 친구들이에요"
        case .follower: return "님을 팔로우하는 친구들이에요"
        }
    }
}
