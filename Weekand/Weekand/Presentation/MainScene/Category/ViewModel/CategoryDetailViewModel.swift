//
//  CategoryDetailViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/14.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class CategoryDetailViewModel {
    
    weak var coordinator: CategoryCoordinator?
    private let categoryUseCase: CategoryUseCase
    private var disposeBag = DisposeBag()
    
    var hasNext: Bool = false
    
    let scheduleList = PublishRelay<[ScheduleSummary]>()
    
    init(coordinator: CategoryCoordinator, categoryUseCase: CategoryUseCase) {
        self.coordinator = coordinator
        self.categoryUseCase = categoryUseCase
    }

}

// MARK: Bind UI
extension CategoryDetailViewModel {
    
    struct Input {
        let didEditSearchBar: Observable<String>
        let didTapUpdateCategoryButton: Observable<Void>
        let scheduleCellDidSelected: PublishRelay<String>
        let scheduleCellDidSwipeEvent: PublishRelay<String>
        let selectedCategory: Category?
    }
    
    struct Output {
        var searchWithQueryInformation: Observable<(String)>
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        let searchBarEdit = input.didEditSearchBar.debounce(.seconds(1), scheduler: MainScheduler.instance)
        
        input.didTapUpdateCategoryButton.subscribe(onNext: {
            guard let category = input.selectedCategory else {
                return
            }
            self.coordinator?.showScheduleAddScene(category: category)
        })
        .disposed(by: disposeBag)
        
        input.scheduleCellDidSwipeEvent.subscribe(onNext: { [weak self] scheduleId in
            self?.coordinator?.showScheduleModifyScene(scheduleId: scheduleId)
        }).disposed(by: disposeBag)
        
        input.scheduleCellDidSelected.subscribe(onNext: { [weak self] scheduleId in
            self?.coordinator?.showScheduleDetailScene(scheduleId: scheduleId)
        })
        .disposed(by: disposeBag)
        
        return Output(searchWithQueryInformation: searchBarEdit)
    }
}

extension CategoryDetailViewModel {
    func deleteSchedule(schedule: ScheduleSummary, completion: @escaping () -> Void) {
        self.categoryUseCase.deleteSchedule(scheduleId: schedule.scheduleId)
            .subscribe(onSuccess: { isSucceed in
                if isSucceed {
                    completion()
                } else {
                    self.coordinator?.showToastMessage(text: "일정 삭제에 실패하였습니다.")
                }
            }, onFailure: { _ in
                self.coordinator?.showToastMessage(text: "일정 삭제에 실패하였습니다.")
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func searchSchedules(sort: ScheduleSort, page: Int, size: Int, searchQuery: String, categoryId: String) {
        
        self.categoryUseCase.searchSchedules(sort: sort, page: page, size: size, searchQuery: searchQuery, categoryId: categoryId)
            .subscribe(onSuccess: { data in
                self.hasNext = data.paginationInfo.hasNext
                let list = data.schedules.map { scedule in
                    ScheduleSummary(model: scedule)
                }
                self.scheduleList.accept(list)
            }, onFailure: { error in
                print(error)
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func loadMoreScheduelList(sort: ScheduleSort, page: Int, size: Int, searchQuery: String, categoryId: String) {
        if hasNext {
            self.searchSchedules(sort: sort, page: page, size: size, searchQuery: searchQuery, categoryId: categoryId)
        }
    }
}
