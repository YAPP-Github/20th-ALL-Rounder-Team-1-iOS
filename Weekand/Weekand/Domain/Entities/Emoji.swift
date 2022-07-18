//
//  Emoji.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/07.
//

import Foundation

/// 스티커 종류
enum Emoji: String {
    case good = "GOOD"           // 좋아요
    case awesome = "LIKE"        // 대단해요
    case cool = "COOL"           // 멋져요
    case support = "CHEER_UP"    // 응원해요
    
    /// 스티커 이미지 이름
    var imageName: String {
        switch self {
        case .good:     return "SmileEmoji"
        case .awesome:  return "GoodEmoji"
        case .cool:     return "CoolEmoji"
        case .support:  return "CongratsEmoji"
        }
    }
    
    /// 스티커 이름
    var emojiName: String {
        switch self {
        case .good:     return "좋아요"
        case .awesome:  return "대단해요"
        case .cool:     return "멋져요"
        case .support:  return "응원해요"
        }
    }
}
