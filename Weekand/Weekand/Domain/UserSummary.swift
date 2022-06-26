//
//  UserSummary.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/23.
//

import Foundation

/// 기본 유저 정보 (이름, 한줄평, 프로필 사진)
struct UserSummary {
    
    static let defaultData = UserSummary(name: "", state: "We can do, Weekand!", imagePath: "")
    
    let name: String        // 유저 이름
    let state: String       // 한줄 목표
    let imagePath: String   // 프로필 사진
}
