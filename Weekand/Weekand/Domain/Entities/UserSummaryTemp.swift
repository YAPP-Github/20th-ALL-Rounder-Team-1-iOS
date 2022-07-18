//
//  UserSummaryTemp.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/15.
//

import Foundation

/// 기본 유저 정보 (이름, 한줄평, 프로필 사진)
struct UserSummaryTemp: Hashable {
    
    static func == (lhs: UserSummaryTemp, rhs: UserSummaryTemp) -> Bool {
      lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    let id = UUID()
    let userSummaryId: String
    let name: String        // 유저 이름
    let goal: String       // 한줄 목표
    let imagePath: String   // 프로필 사진
}
