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
