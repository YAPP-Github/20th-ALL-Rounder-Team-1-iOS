//
//  NetworkError.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/10.
//

import Foundation

enum NetworkError: LocalizedError {
    case duplicatedError
    
    var errorDescription: String? {
        switch self {
        case .duplicatedError:
            return "이미 등록된 이메일입니다."
        }
    }
}
