//
//  CategoryEditViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/14.
//

import Foundation
import RxSwift
import RxCocoa

class CategoryAddViewModel: CategoryEditViewModelType, ViewModelType {
    weak var coordinator: CategoryAddCoordinator?
    
    init(coordinator: CategoryAddCoordinator) {
        
        self.coordinator = coordinator
    }
    
    struct Input {
        let closeButtonDidTapEvent: Observable<Void>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        return Output()
    }

}
