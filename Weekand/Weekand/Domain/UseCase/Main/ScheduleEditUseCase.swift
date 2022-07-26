//
//  ScheduleEditUseCase.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/19.
//

import Foundation
import RxSwift

final class ScheduleEditUseCase {
    func ScheduleCategories(sort: ScheduleSort, page: Int, size: Int) -> Single<ScheduleCategoriesQuery.Data.ScheduleCategory> {
            NetWork.shared.fetch(query: ScheduleCategoriesQuery(sort: sort.toModel(), page: page, size: size),
                                 cachePolicy: .fetchIgnoringCacheCompletely, queue: DispatchQueue.main)
            .map { $0.scheduleCategories }
            .asSingle()
        }
    
    func createSchedule(input: ScheduleInputModel) -> Single<Bool> {
        let scheduleInputModel = ScheduleInput(
            name: input.name,
            categoryId: input.categoryId,
            dateTimeStart: input.dateStart.toTimestamp(),
            dateTimeEnd: input.dateEnd.toTimestamp(),
            repeatType: input.repeatType.toModel(),
            repeatSelectedValue: input.repeatSelectedValue?.map { $0.toModel() },
            repeatEnd: input.repeatEnd?.toTimestamp(),
            memo: input.memo
        )
        
        return NetWork.shared.perform(mutation: CreateScheduleMutation(input: scheduleInputModel))
            .map { $0.createSchedule }
            .asSingle()
        }
    
    func schduleRule(scheduleId: String) -> Single<ScehduleRuleQuery.Data.ScheduleRule> {
        NetWork.shared.fetch(query: ScehduleRuleQuery(scheduleId: scheduleId))
            .map { $0.scheduleRule }
            .asSingle()
    }
}
