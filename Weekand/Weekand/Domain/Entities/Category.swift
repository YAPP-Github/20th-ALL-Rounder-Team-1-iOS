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
    
    let id: String
    let color: String
    let name: String
    let openType: CategoryOpenType
}
