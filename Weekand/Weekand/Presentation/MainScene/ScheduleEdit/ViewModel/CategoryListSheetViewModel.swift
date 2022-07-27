//
//  CategoryListSheetViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class CategoryListSheetViewModel: ViewModelType {
    
    weak var coordinator: ScheduleEditCoordinatorType?
    private let scheduleEditUseCase: ScheduleEditUseCase
    private var disposeBag = DisposeBag()
    
    let categoryList = PublishRelay<[Category]>()
    var hasNext: Bool = false
    
    init(coordinator: ScheduleEditCoordinatorType, scheduleEditUseCase: ScheduleEditUseCase) {
        self.coordinator = coordinator
        self.scheduleEditUseCase = scheduleEditUseCase
    }

}

// MARK: Bind UI
extension CategoryListSheetViewModel {
    
    struct Input {
        let selectedCategory: PublishRelay<Category>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.selectedCategory.subscribe(onNext: { [weak self] category in
            if let coordinator = self?.coordinator as? ScheduleAddCoordinator {
                coordinator.sendCategoryFromSheet(category: category)
                coordinator.finish()
            } else if let coordinator = self?.coordinator as? ScheduleModifyCoordinator {
                coordinator.sendCategoryFromSheet(category: category)
                coordinator.finish()
            }
        })
        .disposed(by: disposeBag)
        
        return Output()
    }
}

extension CategoryListSheetViewModel {
    func searchCategories(sort: ScheduleSort, page: Int, size: Int) {
        
        self.scheduleEditUseCase.ScheduleCategories(sort: sort, page: page, size: size)
            .subscribe(onSuccess: { data in
                self.hasNext = data.paginationInfo.hasNext
                let list = data.scheduleCategories.map { category in
                    Category(serverID: category.id, color: category.color, name: category.name, openType: category.openType.toEntity())
                }
                self.categoryList.accept(list)
            }, onFailure: { error in
                print(error)
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func loadMoreCategoryList(selectedSort: ScheduleSort, page: Int, size: Int) {
        if hasNext {
            self.searchCategories(sort: selectedSort, page: page, size: size)
        }
    }
}
