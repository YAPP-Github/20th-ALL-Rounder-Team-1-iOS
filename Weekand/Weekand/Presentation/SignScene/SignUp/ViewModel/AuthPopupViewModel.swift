//
//  AuthPopupViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/09.
//

import Foundation
import RxSwift
import RxCocoa

class AuthPopupViewModel: ViewModelType {
    
    weak var coordinator: AuthPopupCoordinator?
    private var disposeBag = DisposeBag()

    init(coordinator: AuthPopupCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let confirmButtonDidTapEvent: Observable<Void>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        
        input.confirmButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.dismiss()
        }).disposed(by: disposeBag)
        
        return Output()
    }
}
