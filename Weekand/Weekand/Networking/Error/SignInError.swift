//
//  SignInError.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/26.
//

import Foundation

enum SignInError {
    case notFoundUser
    case notMatchIdPassword
    
    var serverDescription: String {
        switch self {
        case .notFoundUser:
            return "존재하지 않는 유저입니다."
        case .notMatchIdPassword:
            return "이메일, 비밀번호가 일치하지 않습니다."
        }
    }
}
