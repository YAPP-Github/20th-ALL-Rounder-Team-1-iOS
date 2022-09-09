//
//  SimplePopupViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/09.
//

import Foundation
import RxSwift
import RxCocoa

class SimplePopupViewModel: ViewModelType {
    
    weak var coordinator: SimplePopupCoordinator?
    private var disposeBag = DisposeBag()

    init(coordinator: SimplePopupCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let confirmButtonDidTapEvent: Observable<Void>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.confirmButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.dismiss()
        }).disposed(by: disposeBag)
        
        return Output()
    }
}
