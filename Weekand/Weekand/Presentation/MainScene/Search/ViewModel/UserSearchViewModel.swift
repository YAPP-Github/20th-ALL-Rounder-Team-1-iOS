//
//  UserSearchViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/15.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class UserSearchViewModel: ViewModelType {
    
    weak var coordinator: UserSearchCoordinator?
    private var disposeBag = DisposeBag()
    
    var hasNext: Bool = false
    
    init(coordinator: UserSearchCoordinator) {
        self.coordinator = coordinator
    }

}

// MARK: Bind UI
extension UserSearchViewModel {
    
    struct Input {
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
