//
//  UserDetail.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/22.
//

import Foundation

struct UserDetail {
    
    static let defaultData = UserDetail(userId: "", email: "", name: "", goal: "", imagePath: "", followee: -1, follower: -1, job: [], interest: [])
        
    let userId: String      // 유저 id
    let email: String       // 유저 이메일
    let name: String        // 유저 이름
    let goal: String        // 한줄 목표
    let imagePath: String   // 프로필 사진
    let followee: Int       // 팔로워
    let follower: Int       // 팔로잉
    let job: [String]       // 직업
    let interest: [String]  // 관심사
            
}

extension UserDetail {
    
    init (model: MyUserDetailQuery.Data.User) {
        userId = model.id
        email = model.email
        name = model.nickname
        goal = model.goal ?? ""
        imagePath = model.profileUrl
        followee = model.followeeCount
        follower = model.followerCount
        job = model.jobs
        interest = model.interests
    }
}
