//
//  EmojiGiver.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/12.
//

import Foundation

struct EmojiGiver: Hashable {
    
    static func == (lhs: EmojiGiver, rhs: EmojiGiver) -> Bool {
      lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    let id = UUID()
    
    let userId: String
    let name: String
    let imagePath: String
    let emoji: Emoji
}
