//
//  CategoryModifyViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/22.
//

import Foundation
import RxSwift
import RxCocoa

class CategoryModifyViewModel: CategoryEditViewModelType {
    
    weak var coordinator: CategoryModifyCoordinator?
    private let categoryUseCase: CategoryUseCase
    private var disposeBag = DisposeBag()
    
    init(coordinator: CategoryModifyCoordinator, categoryUseCase: CategoryUseCase) {
        self.coordinator = coordinator
        self.categoryUseCase = categoryUseCase
    }
    
    struct Input {
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        return Output()
    }

}
