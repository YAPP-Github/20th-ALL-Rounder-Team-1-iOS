//
//  UserSummary.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/23.
//

import Foundation

/// 기본 유저 정보 (이름, 한줄평, 프로필 사진)
struct UserSummary {
    
    static let defaultData = UserSummary(id: "", name: "", goal: "We can do, Weekand!", imagePath: "")
    
    let userId: String      // 유저 id
    let name: String        // 유저 이름
    let goal: String        // 한줄 목표
    let imagePath: String   // 프로필 사진
    
    init (id: String, name: String, goal: String, imagePath: String) {
        self.userId = id
        self.name = name
        self.goal = goal
        self.imagePath = imagePath
    }
    
    init (model: UserSummaryQuery.Data.User) {
        self.userId = model.id
        self.name = model.nickname
        self.goal = model.goal ?? ""
        self.imagePath = model.profileImageUrl
    }
}
