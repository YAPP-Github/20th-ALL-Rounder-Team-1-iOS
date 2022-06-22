//
//  ScheduleList.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/04.
//

import Foundation

/// 메인 일정 리스트의 일정 정보
struct ScehduleMain: Hashable {
    
    static func == (lhs: ScehduleMain, rhs: ScehduleMain) -> Bool {
      lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    let id = UUID()
    
    let scheduleId: Int
    let color: String
    let name: String
    let dateStart: Date
    let dataEnd: Date
    let stickerCount: Int
    let stickerNameList: [String]
}
