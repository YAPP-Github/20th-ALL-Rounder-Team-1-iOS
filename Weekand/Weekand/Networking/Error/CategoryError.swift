//
//  CategoryError.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/19.
//

import Foundation

enum CategoryError {
    case duplicatedName
    case minimumCategoryCount
    
    var serverDescription: String? {
        switch self {
        case .minimumCategoryCount:
            return "최소 2개 이상의 카테고리가 존재할 시 삭제 가능합니다."
        case .duplicatedName:
            return "해당 카테고리명은 이미 사용중입니다."
        }
    }
}
