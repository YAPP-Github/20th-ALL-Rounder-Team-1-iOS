//
//  ScheduleDetail.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/28.
//

import Foundation

/// 일정 상세 정보
struct ScheduleDetail {
    
    let scheduleId: String
    let category: Category
    let name: String
    let dateStart: Date
    let dateEnd: Date
    let repeatType: ScheduleRepeatType
    let repeatSelectedValue: [ScheduleWeek]
    let repeatEnd: Date?
    let memo: String
    let dateSkip: [Date]?
    let status: Status
    
    init(model: ScheduleQuery.Data.Schedule) {
        self.scheduleId = model.id
        self.category = Category(model: model.category)
        self.name = model.name
        self.dateStart = model.dateTimeStart.toDate()
        self.dateEnd = model.dateTimeEnd.toDate()
        self.repeatType = model.repeatType.toEntity()
        self.repeatSelectedValue = model.repeatSelectedValue.map { $0.toEntity() }
        self.repeatEnd = model.repeatEnd?.toDate()
        self.memo = model.memo ?? ""
        self.dateSkip = model.dateSkip?.map { $0.toDate() }
        self.status = model.status.toEntity()
    }
}
