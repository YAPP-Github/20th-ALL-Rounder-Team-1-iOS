//
//  ProfileSetting.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/21.
//

import Foundation

/// 내 프로필 화면 하단 설정
enum ProfileSetting: String {
    
    case contact = "문의하기"
    case accessibility = "접근성"
    case password = "비밀번호 변경"
    
    case logout = "로그아웃"
    case signOut = "회원탈퇴"
    
    var isCritical: Bool {
        switch self {
        case .contact: return false
        case .accessibility: return false
        case .password: return false
            
        case .logout: return true
        case .signOut: return true
        }
    }
}
