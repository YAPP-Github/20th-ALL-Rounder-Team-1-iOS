//
//  ScheduleList.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/04.
//

import Foundation

struct ScheduleList: Hashable {
    
    static func == (lhs: ScheduleList, rhs: ScheduleList) -> Bool {
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
