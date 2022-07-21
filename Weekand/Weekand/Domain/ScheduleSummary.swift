//
//  ScheduleSummary.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/21.
//

import Foundation

/// 카테고리 내 일정 리스트 정보
struct ScheduleSummary: Hashable {
    
    static func == (lhs: ScheduleSummary, rhs: ScheduleSummary) -> Bool {
      lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    let id = UUID()
    
    let scheduleId: String
    let color: String
    let name: String
    let dateStart: Date
    let dateEnd: Date
    let repeatType: ScheduleRepeatType
    let repeatSelectedValue: String
    
    init(scheduleId: String, color: String, name: String, dateStart: Date, dateEnd: Date, repeatType: ScheduleRepeatType, repeatSelectedValue: String) {
        
        self.scheduleId = scheduleId
        self.color = color
        self.name = name
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.repeatType = repeatType
        self.repeatSelectedValue = repeatSelectedValue
    }
        
    init(model: SearchSchedulesQuery.Data.SearchSchedule.Schedule) {
        
        self.scheduleId = model.id
        self.color = model.category.color
        self.name = model.name
        self.dateStart = model.dateTimeStart.toDate()
        self.dateEnd = model.dateTimeEnd.toDate()
        self.repeatType = model.repeatType.toEntity()
        self.repeatSelectedValue = model.repeatSelectedValue ?? ""
    }
}
