//
//  NetworkError.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/23.
//

import Foundation

enum NetworkError: LocalizedError {
    case expiredToken
    
    var errorDescription: String? {
        switch self {
        case .expiredToken:
            return "유효기간이 만료된 JWT입니다."
        }
    }
}
