//
//  Color.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/26.
//

import Foundation

struct Color: Hashable {
    static func == (lhs: Color, rhs: Color) -> Bool {
      lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    let id: Int
    let hexCode: String
}
