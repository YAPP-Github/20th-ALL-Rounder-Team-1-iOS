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
}
