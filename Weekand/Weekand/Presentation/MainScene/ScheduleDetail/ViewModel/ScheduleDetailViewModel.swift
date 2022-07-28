//
//  ScheduleDetailViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/28.
//

import Foundation
import RxSwift
import RxCocoa

class ScheduleDetailViewModel: ViewModelType {

    weak var coordinator: ScheduleDetailCoordinator?
    private let scheduleDetailUseCase: ScheduleDetailUseCase
    private let disposeBag = DisposeBag()
    
    let schedule = PublishRelay<ScheduleDetail>()
    
    init(coordinator: ScheduleDetailCoordinator?, scheduleDetailUseCase: ScheduleDetailUseCase) {
        self.coordinator = coordinator
        self.scheduleDetailUseCase = scheduleDetailUseCase
    }
    
    struct Input {
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}

extension ScheduleDetailViewModel {
    func schedule(scheduleId: String, requestDate: Date) {
        self.scheduleDetailUseCase.schedule(scheduleId: scheduleId, requestDate: requestDate)
            .subscribe(onSuccess: { schedule in
                let scheduleDetail = ScheduleDetail(model: schedule)
                self.schedule.accept(scheduleDetail)
            }, onFailure: { error in
                print(error)
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
