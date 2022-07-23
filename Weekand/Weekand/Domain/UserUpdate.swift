//
//  UserUpdate.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/23.
//

import Foundation

/// 유저 정보 업데이트에 사용
struct UserUpdate {
    
    let name: String            // 유저 이름
    let goal: String            // 한줄 목표
    let imageFileName: String   // 프로필 사진
    let job: [String]           // 직업
    let interest: [String]      // 관심사
}
