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
    func ScheduleCategories(sort: ScheduleSort, page: Int, size: Int) -> Single<ScheduleCategoriesQuery.Data.ScheduleCategory> {
            NetWork.shared.fetch(query: ScheduleCategoriesQuery(sort: sort.toModel(), page: page, size: size),
                                 cachePolicy: .fetchIgnoringCacheCompletely, queue: DispatchQueue.main)
            .map { $0.scheduleCategories }
            .asSingle()
        }
    
    func createCategory(name: String, color: String, openType: CategoryOpenType) -> Single<Bool> {
        NetWork.shared.perform(mutation: CreateCategoryMutation(name: name, color: color, openType: openType.toModel()))
            .map { $0.createCategory }
            .asSingle()
    }
    
    func updateCategory(id: String, scheduleCategoryInput: ScheduleCategoryInput) -> Single<String> {
        NetWork.shared.perform(mutation: UpdateCategoryMutation(
                                            categoryId: id,
                                            scheduleCategoryInput: scheduleCategoryInput))
        .map { $0.updateCategory.name }
        .asSingle()
    }
}
