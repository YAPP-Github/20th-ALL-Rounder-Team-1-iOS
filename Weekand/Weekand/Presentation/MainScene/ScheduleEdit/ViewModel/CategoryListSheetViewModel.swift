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
                coordinator.navigationController.dismiss(animated: true)
            } else if let coordinator = self?.coordinator as? ScheduleModifyCoordinator {
                coordinator.sendCategoryFromSheet(category: category)
                coordinator.navigationController.dismiss(animated: true)
            }
        })
        .disposed(by: disposeBag)
        
        return Output()
    }
}

// MARK: Network
extension CategoryListSheetViewModel {
    
    /// 카테고리 리스트 
    func searchCategories(sort: ScheduleSort, page: Int, size: Int) {
        
        self.scheduleEditUseCase.ScheduleCategories(sort: sort, page: page, size: size)
            .subscribe(onSuccess: { data in
                self.hasNext = data.paginationInfo.hasNext
                let list = data.scheduleCategories.map { category in
                    Category(serverID: category.id, color: category.color, name: category.name, openType: category.openType.toEntity())
                }
                self.categoryList.accept(list)
            }, onFailure: { _ in
                if let coordinator = self.coordinator as? ScheduleAddCoordinator {
                    coordinator.showToastMessage(text: "카테고리를 가져오지 못했습니다.")
                } else if let coordinator = self.coordinator as? ScheduleModifyCoordinator {
                    coordinator.showToastMessage(text: "카테고리를 가져오지 못했습니다.")
                }
                
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    /// 카테고리 리스트 pagination
    func loadMoreCategoryList(selectedSort: ScheduleSort, page: Int, size: Int) {
        if hasNext {
            self.searchCategories(sort: selectedSort, page: page, size: size)
        }
    }
}
