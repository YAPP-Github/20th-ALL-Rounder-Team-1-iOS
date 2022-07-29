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
        let scheduleId: BehaviorRelay<String>
        let requestDate: Date
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        
        Observable.combineLatest(input.selectedComplete, input.scheduleId)
            .subscribe(onNext: { isTrue, scheduleId in
                if isTrue {
                    self.completeSchedule(scheduleId: scheduleId, requestDate: input.requestDate)
                }
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.selectedInComplete, input.scheduleId)
            .subscribe(onNext: { isTrue, scheduleId in
                if isTrue {
                    self.incompleteSchedule(scheduleId: scheduleId, requestDate: input.requestDate)
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
            }, onFailure: { _ in
                self.coordinator?.showToastMessage(text: "일정 조회에 실패하였습니다.")
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func completeSchedule(scheduleId: String, requestDate: Date) {
        self.scheduleDetailUseCase.completeSchedule(scheduleId: scheduleId, requestDate: requestDate)
            .subscribe(onSuccess: { isSucceed in
                if isSucceed == false {
                    self.coordinator?.showToastMessage(text: "일정 완료를 적용하지 못했습니다.")
                }
            }, onFailure: { _ in
                self.coordinator?.showToastMessage(text: "일정 완료를 적용하지 못했습니다.")
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func incompleteSchedule(scheduleId: String, requestDate: Date) {
        self.scheduleDetailUseCase.incompleteSchedule(scheduleId: scheduleId, requestDate: requestDate)
            .subscribe(onSuccess: { isSucceed in
                if isSucceed == false {
                    self.coordinator?.showToastMessage(text: "일정 미완료를 적용하지 못했습니다.")
                }
            }, onFailure: { _ in
                self.coordinator?.showToastMessage(text: "일정 미완료를 적용하지 못했습니다..")
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
