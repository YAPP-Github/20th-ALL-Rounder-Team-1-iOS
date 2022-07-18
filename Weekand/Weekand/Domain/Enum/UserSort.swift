//
//  UserSort.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/18.
//

import Foundation

enum UserSort: CaseIterable {
    case followerCountDESC
    case dateCreatedDESC
    case nicknameASC
    case nicknameDESC
    
    var description: String {
        switch self {
        case .followerCountDESC:
            return "팔로워순"
        case .dateCreatedDESC:
            return "최신순"
        case .nicknameASC:
            return "오름차순"
        case .nicknameDESC:
            return "내림차순"
        }
    }
}

extension UserSort {
    func toModel() -> SearchUserSort {
        switch self {
        case .dateCreatedDESC:
            return SearchUserSort.dateCreatedDesc
        case .followerCountDESC:
            return SearchUserSort.followerCountDesc
        case .nicknameASC:
            return SearchUserSort.nicknameAsc
        case .nicknameDESC:
            return SearchUserSort.nicknameDesc
        }
    }
}
