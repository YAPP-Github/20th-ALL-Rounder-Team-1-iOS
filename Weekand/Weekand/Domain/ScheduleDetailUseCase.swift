//
//  ScheduleDetailUseCase.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/28.
//

import Foundation
import RxSwift

final class ScheduleDetailUseCase {
    func schedule(scheduleId: String, requestDate: Date) -> Single<ScheduleQuery.Data.Schedule> {
        NetWork.shared.fetch(query: ScheduleQuery(scheduleId: scheduleId, date: requestDate.toTimestamp()),
                             cachePolicy: .fetchIgnoringCacheCompletely,
                             queue: .main)
        .map { $0.schedule }
        .asSingle()
    }
    
    func completeSchedule(scheduleId: String, requestDate: Date) -> Single<Bool> {
        NetWork.shared.perform(mutation: CompleteScheduleMutation(scheduleId: scheduleId, date: requestDate.toTimestamp()))
            .map { $0.completeSchedule }
            .asSingle()
    }
    
    func incompleteSchedule(scheduleId: String, requestDate: Date) -> Single<Bool> {
        NetWork.shared.perform(mutation: IncompleteScheduleMutation(scheduleId: scheduleId, date: requestDate.toTimestamp()))
            .map { $0.incompleteSchedule }
            .asSingle()
    }
}
