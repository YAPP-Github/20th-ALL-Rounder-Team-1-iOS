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
        let isSelectedRepeatEndDate: BehaviorRelay<Bool>
        let selectedRepeatWeek: BehaviorRelay<[ScheduleWeek]>
        let repeatEndDateDidSelectEvent: BehaviorRelay<Date>
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
        
        let selectRepeatEndDate = Observable.combineLatest(input.isSelectedRepeatEndDate, input.repeatEndDateDidSelectEvent, input.selectedRepeatWeek)
        
        input.confirmButtonDidTapEvent
            .withLatestFrom(selectRepeatEndDate)
            .subscribe(onNext: { [weak self] isRepeat, date, weeks in
                let repeatEndDate = isRepeat ? date : nil
                if weeks.count == 7 {
                    self?.coordinator?.sendRepeatTypeFromSheet(repeatType: .daily, repeatEndDate: repeatEndDate)
                } else {
                    self?.coordinator?.sendWeekRepeatTypeFromSheet(repeatType: .weekly, repeatEndDate: repeatEndDate, repeatSelectedValue: weeks)
                }
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
