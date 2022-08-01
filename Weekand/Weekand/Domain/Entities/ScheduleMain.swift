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
    let repeatType: ScheduleRepeatType
        

}

extension ScheduleMain {
    init(model: ScheduleListQuery.Data.Schedule.Schedule) {
        
        self.scheduleId = model.id
        self.color = model.category.color
        self.status = Status(rawValue: model.status.rawValue) ?? .upcoming
        self.name = model.name
        self.dateStart = model.dateTimeStart.toDate()
        self.dateEnd = model.dateTimeEnd.toDate()
        self.stickerCount = model.stickerCount
        self.stickerNameList = model.stickerNames.map { Emoji(rawValue: $0.rawValue) ?? .good }
        self.repeatType = model.repeatType.toEntity()
    }
}
