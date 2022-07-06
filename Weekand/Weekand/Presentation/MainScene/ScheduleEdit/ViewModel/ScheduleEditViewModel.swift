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
    
    enum DateTime {
        case startDate, startTime, endDate, endTime
    }

    weak var coordinator: ScheduleEditCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: ScheduleEditCoordinator?) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let closeButtonDidTapEvent: Observable<Void>
        let isSelectedStartDate: BehaviorRelay<Bool>
        let isSelectedStartTime: BehaviorRelay<Bool>
        let isSelectedEndDate: BehaviorRelay<Bool>
        let isSelectedEndTime: BehaviorRelay<Bool>
        let startDateButtonDidTapEvent: Observable<Void>
        let startTimeButtonDidTapEvent: Observable<Void>
        let endDateButtonDidTapEvent: Observable<Void>
        let endTimeButtonDidTapEvent: Observable<Void>
        let calendarDidSelectEvent: Observable<String>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        input.startDateButtonDidTapEvent
            .subscribe(onNext: { _ in
                input.isSelectedStartDate.accept(!input.isSelectedStartDate.value)
            })
            .disposed(by: disposeBag)
        
        input.startTimeButtonDidTapEvent
            .subscribe(onNext: { _ in
                input.isSelectedStartTime.accept(!input.isSelectedStartTime.value)
            })
            .disposed(by: disposeBag)
        
        input.endDateButtonDidTapEvent
            .subscribe(onNext: { _ in
                input.isSelectedEndDate.accept(!input.isSelectedEndDate.value)
            })
            .disposed(by: disposeBag)
        
        input.endTimeButtonDidTapEvent
            .subscribe(onNext: { _ in
                input.isSelectedEndTime.accept(!input.isSelectedEndTime.value)
            })
            .disposed(by: disposeBag)
        
        input.closeButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.finish()
        }).disposed(by: disposeBag)
        
        var previousTag: DateTime? = nil
        
        Observable.of(
            input.startDateButtonDidTapEvent.map { _ in DateTime.startDate },
            input.startTimeButtonDidTapEvent.map { _ in DateTime.startTime },
            input.endDateButtonDidTapEvent.map { _ in DateTime.endDate },
            input.endTimeButtonDidTapEvent.map { _ in DateTime.endTime }
        )
        .merge()
        .distinctUntilChanged()
        .subscribe(onNext: { tag in
            switch previousTag {
            case .startDate:
                input.isSelectedStartDate.accept(false)
            case .startTime:
                input.isSelectedStartTime.accept(false)
            case .endDate:
                input.isSelectedEndDate.accept(false)
            case .endTime:
                input.isSelectedEndTime.accept(false)
            default:
                break
            }
            previousTag = tag
        })
        .disposed(by: disposeBag)
        
        return Output()
    }
}
