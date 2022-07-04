//
//  CategoryListFilterViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/27.
//

import Foundation
import RxSwift
import RxCocoa

class CategoryListFilterViewModel: ViewModelType {
    
    weak var coordinator: CategoryCoordinator?
    private var disposeBag = DisposeBag()

    init(coordinator: CategoryCoordinator) {
        
        self.coordinator = coordinator
    }
    
    struct Input {
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }

}
