//
//  ScheduleEditViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/05.
//

import Foundation
import RxSwift
import RxCocoa
import Apollo

class ScheduleEditViewModel: ViewModelType {
    
    enum DateTime {
        case startDate, startTime, endDate, endTime
    }

    weak var coordinator: ScheduleEditCoordinator?
    var scheduleEditUseCase: ScheduleEditUseCase
    private let disposeBag = DisposeBag()
    
    let defaultCategory = PublishRelay<Category>()
    
    init(coordinator: ScheduleEditCoordinator?, scheduleEditUseCase: ScheduleEditUseCase) {
        self.coordinator = coordinator
        self.scheduleEditUseCase = scheduleEditUseCase
    }
    
    struct Input {
        let closeButtonDidTapEvent: Observable<Void>
        let categoryArrowDidTapEvent: Observable<Void>
        let isSelectedStartDate: BehaviorRelay<Bool>
        let isSelectedStartTime: BehaviorRelay<Bool>
        let isSelectedEndDate: BehaviorRelay<Bool>
        let isSelectedEndTime: BehaviorRelay<Bool>
        let startDateButtonDidTapEvent: Observable<Void>
        let startTimeButtonDidTapEvent: Observable<Void>
        let endDateButtonDidTapEvent: Observable<Void>
        let endTimeButtonDidTapEvent: Observable<Void>
        let startDateDidSelectEvent: Observable<Date>
        let endDateDidSelectEvent: Observable<Date>
        let repeatButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var startDateDidSelectEvent: Driver<Date>
        var endDateDidSelectEvent: Driver<Date>
    }
    
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
        
        input.repeatButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.presentRepeatSheet()
        })
        .disposed(by: disposeBag)
        
        input.categoryArrowDidTapEvent.subscribe(onNext: {
            self.coordinator?.presentCategorySheet()
        })
        .disposed(by: disposeBag)
        
        return Output(
            startDateDidSelectEvent: input.startDateDidSelectEvent.asDriver(onErrorJustReturn: Date()),
            endDateDidSelectEvent: input.endDateDidSelectEvent.asDriver(onErrorJustReturn: Date())
        )
    }
}

extension ScheduleEditViewModel {
    func searchCategories() {
        self.scheduleEditUseCase.ScheduleCategories(sort: .dateCreatedDESC, page: 0, size: 1)
            .subscribe(onSuccess: { data in
                let list = data.scheduleCategories.map { category in
                    Category(serverID: category.id, color: category.color, name: category.name, openType: category.openType.toEntity())
                }
                
                guard let category = list.first else {
                    // error
                    return
                }
                self.defaultCategory.accept(category)
            }, onFailure: { error in
                print(error)
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
