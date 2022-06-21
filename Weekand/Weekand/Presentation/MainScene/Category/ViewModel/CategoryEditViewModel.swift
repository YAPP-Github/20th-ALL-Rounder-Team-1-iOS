//
//  CategoryEditViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/14.
//

import Foundation
import RxSwift
import RxCocoa

class CategoryEditViewModel: ViewModelType {
    
    weak var coordinator: CategoryEidtCoordinator?
    
    init(coordinator: CategoryEidtCoordinator) {
        
        self.coordinator = coordinator
    }
    
    struct Input {
        let closeButtonDidTapEvent: Observable<Void>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        input.closeButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.dismiss()
        })
        
        return Output()
    }

}
