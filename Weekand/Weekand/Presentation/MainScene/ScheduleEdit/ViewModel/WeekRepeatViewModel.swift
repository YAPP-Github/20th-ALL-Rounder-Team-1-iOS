//
//  WeekRepeatViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/22.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class WeekRepeatViewModel: ViewModelType {
    
    weak var coordinator: ScheduleEditCoordinator?
    private var disposeBag = DisposeBag()
    
    init(coordinator: ScheduleEditCoordinator) {
        self.coordinator = coordinator
    }

}

// MARK: Bind UI
extension WeekRepeatViewModel {
    
    struct Input {
        let cancelButtonDidTapEvent: Observable<Void>
        let confirmButtonDidTapEvent: Observable<Void>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        input.cancelButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.finish()
        })
        .disposed(by: disposeBag)
        
        input.confirmButtonDidTapEvent.subscribe(onNext: {
        })
        .disposed(by: disposeBag)
        
        return Output()
    }
}

