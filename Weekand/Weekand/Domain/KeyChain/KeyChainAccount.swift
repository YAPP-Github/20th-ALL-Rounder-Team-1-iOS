//
//  KeyChainAccount.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/24.
//

import Foundation

enum KeyChainAccount {
    case accessToken
    case refreshToken
    case userId
    case password
    
    var description: String {
        return String(describing: self)
    }
    
    var keyChainClass: CFString {
        switch self {
        case .accessToken:
            return kSecClassGenericPassword
        case .refreshToken:
            return kSecClassGenericPassword
        case .userId:
            return kSecClassInternetPassword
        case .password:
            return kSecClassInternetPassword
        }
    }
}
