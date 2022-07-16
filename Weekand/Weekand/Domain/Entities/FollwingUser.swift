//
//  FollwingUser.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/20.
//

import Foundation

/// 메인화면 팔로잉 목록
struct FollowingUser: Hashable {
    
    static func == (lhs: FollowingUser, rhs: FollowingUser) -> Bool {
      lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    let id = UUID()
    
    let userId: String
    let name: String
    let imagePath: String
    
    init(userId: String, name: String, imagePath: String) {
        self.userId = userId
        self.name = name
        self.imagePath = imagePath
    }
    
    init (model: FollowersQuery.Data.Follower.Follower) {
        self.userId = model.id ?? ""
        self.name = model.nickname ?? ""
        self.imagePath = model.profileUrl ?? ""
    }
}
