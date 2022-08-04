//
//  AlertPopupViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/30.
//

import Foundation
import RxSwift

class AlertPopupViewModel: ViewModelType {
    
    weak var coordinator: AlertPopupCoordinator?
    private var disposeBag = DisposeBag()
    var completionHandler: () -> Void

    init(coordinator: AlertPopupCoordinator, completionHandler: @escaping () -> Void) {
        self.coordinator = coordinator
        self.completionHandler = completionHandler
    }
    
    struct Input {
        let confirmButtonDidTapEvent: Observable<Void>
        let cancelButtonDidTapEvent: Observable<Void>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        
        input.confirmButtonDidTapEvent.subscribe(onNext: {
            self.completionHandler()
            self.coordinator?.dismiss()
        }).disposed(by: disposeBag)
        
        input.cancelButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.dismiss()
        }).disposed(by: disposeBag)
        
        return Output()
    }
}
