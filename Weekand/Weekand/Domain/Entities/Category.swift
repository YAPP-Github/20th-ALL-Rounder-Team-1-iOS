//
//  Category.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/12.
//

import Foundation

struct Category: Hashable {
    
    static func == (lhs: Category, rhs: Category) -> Bool {
      lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }
    
    let identifier = UUID()
    let serverID: String
    let color: String
    let name: String
    let openType: CategoryOpenType
}
