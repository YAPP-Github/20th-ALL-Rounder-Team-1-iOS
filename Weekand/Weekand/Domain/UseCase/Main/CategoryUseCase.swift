//
//  CategoryUseCase.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/12.
//
import Foundation
import RxSwift

typealias Categories = [ScheduleCategoriesQuery.Data.ScheduleCategory.ScheduleCategory]

final class CategoryUseCase {
    func ScheduleCategories(sort: ScheduleSort, page: Int, size: Int) -> Single<Categories> {
        NetWork.shared.fetch(query: ScheduleCategoriesQuery(sort: sort.toModel(), page: page, size: size))
            .map { $0.scheduleCategories.scheduleCategories }
            .asSingle()
    }
}
