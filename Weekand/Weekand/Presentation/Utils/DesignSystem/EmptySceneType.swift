//
//  EmptySceneType.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/26.
//

import Foundation

enum EmptySceneType {
    case schedule
    case followerSchedule
    case search
    case folloewr
    case following
    case alarm
    
    var imageName: String {
        switch self {
        case .schedule:
            return "scheduleEmoji.empty"
        case .followerSchedule:
            return "scheduleEmoji.empty"
        case .search:
            return "searchEmoji.empty"
        case .folloewr:
            return "followersEmoji.empty"
        case .following:
            return "followingEmoji.empty"
        case .alarm:
            return "alarmEmoji.empty"
        }
    }
    
    var informText: String {
        switch self {
        case .schedule:
            return "일정을 만들어보세요!"
        case .followerSchedule:
            return "오늘 친구 일정이 없어요"
        case .search:
            return "찾으시는 검색 결과가 없어요"
        case .folloewr:
            return "나를 팔로우하는 친구가\n여기에 표시됩니다"
        case .following:
            return "친구를 팔로우해 보세요"
        case .alarm:
            return "아직 소식이 없어요"
        }
    }
}
