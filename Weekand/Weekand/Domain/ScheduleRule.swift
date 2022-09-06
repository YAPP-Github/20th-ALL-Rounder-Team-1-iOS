//
//  ScheduleDetail.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/26.
//

import Foundation

/// 일정 상세 정보
struct ScheduleRule {
    
    let scheduleId: String
    let category: Category
    let name: String
    let dateStart: Date
    let dateEnd: Date
    let repeatType: ScheduleRepeatType
    let repeatSelectedValue: [ScheduleWeek]
    let repeatEnd: Date?
    let memo: String
    
    init(model: ScehduleRuleQuery.Data.ScheduleRule) {
        
        self.scheduleId = model.id
        self.category = Category(model: model.category)
        self.name = model.name
        self.dateStart = model.dateTimeStart.toDate()
        self.dateEnd = model.dateTimeEnd.toDate()
        self.repeatType = model.repeatType.toEntity()
        self.repeatSelectedValue = model.repeatSelectedValue.map { $0.toEntity() }
        self.repeatEnd = model.repeatEnd?.toDate()
        self.memo = model.memo ?? ""
    }
}
