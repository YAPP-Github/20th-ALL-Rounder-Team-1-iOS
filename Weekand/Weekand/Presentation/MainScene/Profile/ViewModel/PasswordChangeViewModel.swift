//
//  PasswordChangeViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/25.
//

import Foundation
import RxSwift

class PasswordChangeViewModel: ViewModelType {

    weak var coordinator: ProfileCoordinator?
    private let profileUseCase: ProfileUseCase
    private let disposeBag = DisposeBag()
    
    init (coordinator: ProfileCoordinator, useCase: ProfileUseCase) {
        self.coordinator = coordinator
        self.profileUseCase = useCase
        
    }

}

extension PasswordChangeViewModel {
    
    struct Input { }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
