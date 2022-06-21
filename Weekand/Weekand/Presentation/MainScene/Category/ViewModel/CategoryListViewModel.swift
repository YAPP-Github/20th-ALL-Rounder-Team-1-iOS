//
//  CategoryListViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/14.
//

import Foundation
import RxSwift

class CategoryListViewModel {
    
    weak var coordinator: CategoryCoordinator?
    private var disposeBag = DisposeBag()
    
    init(coordinator: CategoryCoordinator) {
        self.coordinator = coordinator
    }

}

// MARK: Bind UI
extension CategoryListViewModel {
    
    struct Input {
        let didTapAddCategoryButton: Observable<Void>
        let didCategoryCellSelected: Observable<IndexPath>   // TODO: Cell의 Category-ID를 받아오도록 수정 (모델 구현 이후 진행)
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.didTapAddCategoryButton.subscribe(onNext: { [weak self] _ in
            self?.coordinator?.showCategoryEditScene()
        }).disposed(by: disposeBag)
        
        input.didCategoryCellSelected.subscribe(onNext: { [weak self] _ in
            self?.coordinator?.pushCategoryDetailViewController()
        }).disposed(by: disposeBag)
        
        return output
    }
}
