//
//  UserDetail.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/22.
//

import Foundation

struct UserDetail {
    
    static let defaultData = UserDetail(userId: "", email: "", name: "", goal: "", imagePath: "", followee: 0, follower: 0, job: [], interest: [], followed: false)
        
    let userId: String      // 유저 id
    let email: String       // 유저 이메일
    let name: String        // 유저 이름
    let goal: String        // 한줄 목표
    let imagePath: String   // 프로필 사진
    let followee: Int       // 팔로워
    let follower: Int       // 팔로잉
    let job: [String]       // 직업
    let interest: [String]  // 관심사
    let followed: Bool      // 팔로우 여부
}

extension UserDetail {
    
    init (model: UserDetailQuery.Data.User) {
        userId = model.id
        email = model.email
        name = model.nickname
        goal = model.goal ?? ""
        imagePath = model.profileImageUrl
        followee = model.followeeCount
        follower = model.followerCount
        job = model.jobs
        interest = model.interests
        followed = model.followed
    }
}
