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
        
        return Output(searchWithQueryInformation: searchBarEdit)
    }
}

extension CategoryDetailViewModel {
    func searchSchedules(id: String, completion: @escaping () -> Void) {
        self.categoryUseCase.deleteCategory(id: id)
            .subscribe(onSuccess: { isSucceed in
                if isSucceed {
                    completion()
                } else {
                    self.coordinator?.showToastMessage(text: "일정 삭제에 실패하였습니다.")
                }
            }, onFailure: { error in
                if error.localizedDescription == CategoryError.minimumCategoryCount.serverDescription {
                    self.coordinator?.showToastMessage(text: error.localizedDescription)
                } else {
                    self.coordinator?.showToastMessage(text: "일정 삭제에 실패하였습니다.")
                }
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
