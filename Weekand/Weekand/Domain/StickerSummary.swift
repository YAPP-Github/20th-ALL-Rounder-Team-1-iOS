//
//  StickerSummary.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/28.
//

import Foundation

/// 스티커 데이터 (전체)
struct StickerSummary {
    
    let totalCount: Int
    let scheduleStickers: [Emoji: Int]
    let scheduleStickerUser: [EmojiGiver]
}

extension StickerSummary {
    
    init(model: StickerSummaryQuery.Data.ScheduleStickerSummary) {
        totalCount = model.totalCount
        
        var stickers: [Emoji: Int] = [:]
        model.scheduleStickers.forEach {
            guard let emoji = Emoji(rawValue: $0.name.rawValue) else { return }
            stickers[emoji] = $0.stickerCount
        }
        scheduleStickers = stickers
        
        scheduleStickerUser = model.scheduleStickerUsers.map {
            
            EmojiGiver(userId: $0.user.id, name: $0.user.nickname, imagePath: $0.user.profileImageUrl, emoji: Emoji(rawValue: $0.stickerName.rawValue) ?? Emoji.good)
        }
        
    }
}
