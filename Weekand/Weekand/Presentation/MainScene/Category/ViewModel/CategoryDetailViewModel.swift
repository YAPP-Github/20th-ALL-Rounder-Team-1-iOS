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
    
    init(coordinator: CategoryCoordinator, categoryUseCase: CategoryUseCase) {
        self.coordinator = coordinator
        self.categoryUseCase = categoryUseCase
    }

}

// MARK: Bind UI
extension CategoryDetailViewModel {
    
    struct Input {
        let dropDownDidSelectEvent: BehaviorRelay<ScheduleSort>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
