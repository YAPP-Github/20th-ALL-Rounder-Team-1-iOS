//
//  CategoryListViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/14.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class CategoryListViewModel {
    
    weak var coordinator: CategoryCoordinator?
    private let categoryUseCase: CategoryUseCase
    private var disposeBag = DisposeBag()
    
    init(coordinator: CategoryCoordinator, categoryUseCase: CategoryUseCase) {
        self.coordinator = coordinator
        self.categoryUseCase = categoryUseCase
    }

}

// MARK: Bind UI
extension CategoryListViewModel {
    
    struct Input {
        let didTapAddCategoryButton: Observable<Void>
        let didCategoryCellSelected: Observable<IndexPath>   // TODO: Cell의 Category-ID를 받아오도록 수정 (모델 구현 이후 진행)
        let dropDownDidSelectEvent: BehaviorRelay<Sort>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.didTapAddCategoryButton.subscribe(onNext: { [weak self] _ in
            self?.coordinator?.showCategoryAddScene()
        }).disposed(by: disposeBag)
        
        input.didCategoryCellSelected.subscribe(onNext: { [weak self] _ in
            self?.coordinator?.pushCategoryDetailViewController()
        }).disposed(by: disposeBag)
        
        return Output()
    }
}
