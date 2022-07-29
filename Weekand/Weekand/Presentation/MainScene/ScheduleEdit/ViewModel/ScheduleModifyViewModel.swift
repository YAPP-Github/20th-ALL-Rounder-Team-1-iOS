//
//  ScheduleModifyViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/26.
//

import Foundation
import RxSwift
import RxCocoa
import Apollo

class ScheduleModifyViewModel: ScheduleEditViewModelType {
    
    enum DateTime {
        case date, startTime, endTime
    }

    weak var coordinator: ScheduleModifyCoordinator?
    var scheduleEditUseCase: ScheduleEditUseCase
    private let disposeBag = DisposeBag()
    
    let defaultCategory = PublishRelay<Category>()
    let schedule = PublishRelay<ScheduleRule>()
    let scheduleId: String
    
    init(coordinator: ScheduleModifyCoordinator?, scheduleEditUseCase: ScheduleEditUseCase, scheduleId: String) {
        self.coordinator = coordinator
        self.scheduleEditUseCase = scheduleEditUseCase
        self.scheduleId = scheduleId
    }
    
    struct Input {
        let closeButtonDidTapEvent: Observable<Void>
        let confirmButtonDidTapEvent: Observable<Void>
        let categoryArrowDidTapEvent: Observable<Void>
        let isSelectedDate: BehaviorRelay<Bool>
        let isSelectedStartTime: BehaviorRelay<Bool>
        let isSelectedEndTime: BehaviorRelay<Bool>
        let dateButtonDidTapEvent: Observable<Void>
        let startTimeButtonDidTapEvent: Observable<Void>
        let endTimeButtonDidTapEvent: Observable<Void>
        let dateDidSelectEvent: Observable<Date>
        let repeatButtonDidTapEvent: Observable<Void>
        let selectedScheduleName: BehaviorRelay<String>
        let selectedDate: BehaviorRelay<Date>
        let selectedStartTime: BehaviorRelay<Date>
        let selectedEndTime: BehaviorRelay<Date>
        let selectedCategory: BehaviorRelay<Category?>
        let selectedRepeatType: BehaviorRelay<ScheduleRepeatType>
        let selectedRepeatSelectedValue: BehaviorRelay<[ScheduleWeek]>
        let selectedRepeatEnd: BehaviorRelay<Date?>
        let selectedMemo: BehaviorRelay<String>
        let requestDate: Date
    }
    
    struct Output {
        var dateDidSelectEvent: Driver<Date>
        var validNameInput: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let combinedDateTimes = Observable.combineLatest(input.selectedDate,
                                                         input.selectedStartTime,
                                                         input.selectedEndTime)
        let validNameInput = input.selectedScheduleName.map(vaildInput)
        
        let combinedInputs = Observable.combineLatest(
             combinedDateTimes,
             input.selectedScheduleName,
             input.selectedCategory,
             input.selectedRepeatType,
             input.selectedRepeatSelectedValue,
             input.selectedRepeatEnd,
             input.selectedMemo)
        
        input.confirmButtonDidTapEvent.withLatestFrom(combinedInputs)
            .subscribe(onNext: { dates, nameText, category, repeatType, repeatSelectValue, repeatEnd, memo in
                guard let category = category else {
                    return
                }
                
                guard memo.count <= 500 else {
                    print("error")
                    return
                }
                
                let scheduleUpdateModel = ScheduleUpdateModel(
                    scheduleId: self.scheduleId,
                    requestDateTime: input.requestDate,
                    name: nameText,
                    categoryId: category.serverID,
                    dateStart: WDateFormatter.combineDate(date: dates.0, time: dates.1),
                    dateEnd: WDateFormatter.combineDate(date: dates.0, time: dates.2),
                    repeatType: repeatType,
                    repeatSelectedValue: repeatSelectValue,
                    repeatEnd: repeatEnd,
                    memo: memo == "" ? nil : memo
                )
                
                self.updateSchedule(input: scheduleUpdateModel)
            })
            .disposed(by: disposeBag)

        self.bindDateTime(input: input)
        
        input.repeatButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.presentRepeatSheet()
        })
        .disposed(by: disposeBag)
        
        input.categoryArrowDidTapEvent.subscribe(onNext: {
            self.coordinator?.presentCategorySheet()
        })
        .disposed(by: disposeBag)
        
        return Output(
            dateDidSelectEvent: input.dateDidSelectEvent.asDriver(onErrorJustReturn: Date()),
            validNameInput: validNameInput.asDriver(onErrorJustReturn: false)
        )
    }
    
    private func bindDateTime(input: Input) {
        input.dateButtonDidTapEvent
            .subscribe(onNext: { _ in
                input.isSelectedDate.accept(!input.isSelectedDate.value)
            })
            .disposed(by: disposeBag)
        
        input.startTimeButtonDidTapEvent
            .subscribe(onNext: { _ in
                input.isSelectedStartTime.accept(!input.isSelectedStartTime.value)
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
            input.dateButtonDidTapEvent.map { _ in DateTime.date },
            input.startTimeButtonDidTapEvent.map { _ in DateTime.startTime },
            input.endTimeButtonDidTapEvent.map { _ in DateTime.endTime }
        )
        .merge()
        .distinctUntilChanged()
        .subscribe(onNext: { tag in
            switch previousTag {
            case .date:
                input.isSelectedDate.accept(false)
            case .startTime:
                input.isSelectedStartTime.accept(false)
            case .endTime:
                input.isSelectedEndTime.accept(false)
            default:
                break
            }
            previousTag = tag
        })
        .disposed(by: disposeBag)
    }
    
    func vaildInput(name: String?) -> Bool {
        if let name = name {
            if name.isEmpty {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
}

extension ScheduleModifyViewModel {
    func getSchedule() {
        self.scheduleEditUseCase.schduleRule(scheduleId: self.scheduleId)
            .subscribe(onSuccess: { schedule in
                let scheduleRule = ScheduleRule(model: schedule)
                self.schedule.accept(scheduleRule)
                self.defaultCategory.accept(scheduleRule.category)
            }, onFailure: { error in
                print(error)
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func updateSchedule(input: ScheduleUpdateModel) {
        self.scheduleEditUseCase.updateSchedule(input: input)
            .subscribe(onSuccess: { isSucceed in
                if isSucceed {
                    self.coordinator?.finish()
                } else {
                    print("error")
                }
            }, onFailure: { error in
                print(error)
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
