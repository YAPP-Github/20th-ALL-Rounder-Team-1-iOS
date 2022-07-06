//
//  ScheduleEditViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/05.
//

import Foundation
import RxSwift
import RxCocoa

class ScheduleEditViewModel: ViewModelType {

    weak var coordinator: ScheduleEditCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: ScheduleEditCoordinator?) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let closeButtonDidTapEvent: Observable<Void>
        let startDateButionDidTapEvent: Observable<Void>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        input.closeButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.finish()
        }).disposed(by: disposeBag)
        
        let buttonsEvent = [input.startDateButionDidTapEvent]
        
        let selectedButtons = input.startDateButionDidTapEvent.scan(false) { lastState, _ in !lastState }
        
        return Output()
    }
}
