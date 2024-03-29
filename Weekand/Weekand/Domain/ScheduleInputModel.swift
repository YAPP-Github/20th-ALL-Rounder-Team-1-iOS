//
//  ScheduleInputModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/22.
//

import Foundation

struct ScheduleInputModel {
    let name: String
    let categoryId: String
    let dateStart: Date
    let dateEnd: Date
    let repeatType: ScheduleRepeatType
    let repeatSelectedValue: [ScheduleWeek]?
    let repeatEnd: Date?
    let memo: String?
}
