//
//  ContactViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/24.
//

import Foundation
import RxSwift

class ContactViewModel: ViewModelType {

    weak var coordinator: ProfileCoordinator?
    private let profileUseCase: ProfileUseCase
    private let disposeBag = DisposeBag()
    
    init (coordinator: ProfileCoordinator, useCase: ProfileUseCase) {
        self.coordinator = coordinator
        self.profileUseCase = useCase
        
    }
    
}

extension ContactViewModel {
    
    struct Input { }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
