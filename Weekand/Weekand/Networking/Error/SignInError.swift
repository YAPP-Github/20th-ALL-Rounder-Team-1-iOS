//
//  SignInError.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/26.
//

import Foundation

enum SignInError {
    case noExistUser
    
    var serverDescription: String {
        switch self {
        case .noExistUser:
            return "존재하지 않는 유저입니다."
        }
    }
}
