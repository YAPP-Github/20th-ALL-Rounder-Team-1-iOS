//
//  Category.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/12.
//

import Foundation

struct Category: Hashable {
    
    static func == (lhs: Category, rhs: Category) -> Bool {
      lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    let id = UUID()
    
    let color: String
    let name: String
    let openType: OpenType
}

enum OpenType {
    case allOpen
    case followerOpen
    case closed
    
    var description: String {
        switch self {
        case .allOpen:
            return "모두 공개"
        case .followerOpen:
            return "친구 공개"
        case .closed:
            return "비공개"
        }
    }
}
