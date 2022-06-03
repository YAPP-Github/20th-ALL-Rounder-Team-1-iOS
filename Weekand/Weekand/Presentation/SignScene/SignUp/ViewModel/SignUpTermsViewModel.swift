//
//  SignUpTermsViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/04.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpTermsViewModel: ViewModelType {

    weak var coordinator: SignUpCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: SignUpCoordinator?) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let nextButtonDidTapEvent: Observable<Void>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {

        input.nextButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.finish()
        })
        .disposed(by: disposeBag)
        
        return Output()
    }
}
