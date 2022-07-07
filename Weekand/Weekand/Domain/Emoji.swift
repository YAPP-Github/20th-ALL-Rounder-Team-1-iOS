//
//  Emoji.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/07.
//

import Foundation

enum Emoji {
    case good       // 좋아요
    case awesome    // 대단해요
    case cool       // 멋져요
    case support    // 응원해요
    
    var imageName: String {
        switch self {
        case .good:     return "SmileEmoji"
        case .awesome:  return "GoodEmoji"
        case .cool:     return "CoolEmoji"
        case .support:  return "CongratsEmoji"
        }
    }
    
    var emojiName: String {
        switch self {
        case .good:     return "좋아요"
        case .awesome:  return "대단해요"
        case .cool:     return "멋져요"
        case .support:  return "응원해요"
        }
    }
}
