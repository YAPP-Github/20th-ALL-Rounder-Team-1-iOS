//
//  CategoryModifyViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/22.
//

import Foundation
import RxSwift
import RxCocoa

class CategoryModifyViewModel: CategoryEditViewModelType, ViewModelType {
    
    weak var coordinator: CategoryModifyCoordinator?
    
    init(coordinator: CategoryModifyCoordinator) {
        
        self.coordinator = coordinator
    }
    
    struct Input {
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        return Output()
    }

}
