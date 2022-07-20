//
//  ScheduleList.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/04.
//

import Foundation

/// 메인 일정 리스트의 일정 정보
struct ScheduleMain: Hashable {
    
    static func == (lhs: ScheduleMain, rhs: ScheduleMain) -> Bool {
      lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    let id = UUID()
    
    let scheduleId: String
    let color: String
    let status: Status
    let name: String
    let dateStart: Date
    let dateEnd: Date
    let stickerCount: Int
    let stickerNameList: [Emoji]
    
    init(scheduleId: String, color: String, status: Status,  name: String, dateStart: Date, dateEnd: Date, stickerCount: Int, stickerNameList: [Emoji]) {
        
        self.scheduleId = scheduleId
        self.color = color
        self.status = status
        self.name = name
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.stickerCount = stickerCount
        self.stickerNameList = stickerNameList
    }
        
    init(model: ScheduleListQuery.Data.Schedule.Schedule) {
        
        self.scheduleId = model.id
        self.color = model.category.color
        self.status = Status(rawValue: model.status.rawValue) ?? .upcoming
        self.name = model.name
        self.dateStart = model.dateTimeStart.toDate()
        self.dateEnd = model.dateTimeEnd.toDate()
        self.stickerCount = model.stickerCount
        self.stickerNameList = model.stickerNames.map { Emoji(rawValue: $0.rawValue) ?? .good }
    }
}
