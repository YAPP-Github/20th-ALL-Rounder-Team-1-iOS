//
//  RepeatViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/22.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class DefaultRepeatViewModel: ViewModelType {
    
    weak var coordinator: ScheduleEditCoordinatorType?
    private var disposeBag = DisposeBag()
    
    var repeatType: ScheduleRepeatType?
    
    init(coordinator: ScheduleEditCoordinatorType, repeatType: ScheduleRepeatType) {
        self.coordinator = coordinator
        self.repeatType = repeatType
    }

}

// MARK: Bind UI
extension DefaultRepeatViewModel {
    
    struct Input {
        let isSelectedRepeatEndDate: BehaviorRelay<Bool>
        let repeatEndDateDidSelectEvent: BehaviorRelay<Date>
        let cancelButtonDidTapEvent: Observable<Void>
        let confirmButtonDidTapEvent: Observable<Void>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        input.cancelButtonDidTapEvent.subscribe(onNext: {
            if let coordinator = self.coordinator as? ScheduleAddCoordinator {
                coordinator.navigationController.dismiss(animated: true)
            } else if let coordinator = self.coordinator as? ScheduleModifyCoordinator {
                coordinator.navigationController.dismiss(animated: true)
            }
        })
        .disposed(by: disposeBag)
        
        let selectRepeatEndDate = Observable.combineLatest(input.repeatEndDateDidSelectEvent, input.isSelectedRepeatEndDate)
        
        input.confirmButtonDidTapEvent
            .withLatestFrom(selectRepeatEndDate)
            .subscribe(onNext: { [weak self] date, isRepeat in
                let repeatEndDate = isRepeat ? date : nil
                if let coordinator = self?.coordinator as? ScheduleAddCoordinator {
                    coordinator.sendRepeatTypeFromSheet(repeatType: self?.repeatType ?? .once, repeatEndDate: repeatEndDate)
                    self?.coordinator?.navigationController.dismiss(animated: true)
                } else if let coordinator = self?.coordinator as? ScheduleModifyCoordinator {
                    coordinator.sendRepeatTypeFromSheet(repeatType: self?.repeatType ?? .once, repeatEndDate: repeatEndDate)
                    self?.coordinator?.navigationController.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
