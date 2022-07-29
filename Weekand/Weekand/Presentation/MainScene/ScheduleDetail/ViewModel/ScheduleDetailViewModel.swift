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
        let selectedComplete: BehaviorRelay<Bool>
        let selectedInComplete: BehaviorRelay<Bool>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        
        input.selectedComplete.subscribe(onNext: { isTrue in
            if isTrue {
                print("완료")
            }
        })
        .disposed(by: disposeBag)
        
        input.selectedInComplete.subscribe(onNext: { isTrue in
            if isTrue {
                print("미완료")
            }
        })
        .disposed(by: disposeBag)
        
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
    
    func completeSchedule(scheduleId: String, requestDate: Date) {
        self.scheduleDetailUseCase.completeSchedule(scheduleId: scheduleId, requestDate: requestDate)
            .subscribe(onSuccess: { isSucceed in
                if isSucceed == false {
                    print("error")
                }
            }, onFailure: { error in
                print(error)
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func incompleteSchedule(scheduleId: String, requestDate: Date) {
        self.scheduleDetailUseCase.incompleteSchedule(scheduleId: scheduleId, requestDate: requestDate)
            .subscribe(onSuccess: { isSucceed in
                if isSucceed == false {
                    print("error")
                }
            }, onFailure: { error in
                print(error)
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
