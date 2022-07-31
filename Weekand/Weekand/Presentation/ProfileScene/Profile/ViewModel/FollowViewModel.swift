//
//  FollowViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/31.
//

import Foundation
import RxSwift

class FollowViewModel: ViewModelType {
    
    weak var coordinator: ProfileCoordinator?
    private let profileUseCase: ProfileUseCase
    private let disposeBag = DisposeBag()
    var type: FollowInformationType
    var id: String
    
    init (coordinator: ProfileCoordinator, useCase: ProfileUseCase, id: String, type: FollowInformationType) {
        self.coordinator = coordinator
        self.profileUseCase = useCase
        self.id = id
        self.type = type
    }
}

extension FollowViewModel {
    
    struct Input { }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
