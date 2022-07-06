//
//  PasswordFindViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/28.
//

import Foundation
import RxSwift
import RxCocoa

class PasswordFindViewModel: ViewModelType {
    weak var coordinator: PasswordFindCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: PasswordFindCoordinator?) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let closeButtonDidTapEvent: Observable<Void>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        input.closeButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.finish()
        }).disposed(by: disposeBag)
        
        return Output()
    }
}
