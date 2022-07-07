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
    
    init(coordinator: CategoryCoordinator) {
        
        self.coordinator = coordinator
    }

}

// MARK: Bind UI
extension CategoryDetailViewModel {
    
    struct Input {
        let dropDownDidSelectEvent: BehaviorRelay<Sort>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
