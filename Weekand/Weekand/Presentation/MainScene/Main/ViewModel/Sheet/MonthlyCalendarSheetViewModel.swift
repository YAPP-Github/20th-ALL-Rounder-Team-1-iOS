//
//  MonthlyCalendarSheetViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/07.
//

import Foundation
import RxSwift

class MonthlyCalendarSheetViewModel {
    
    weak var coordinator: MainCoordinator?
    private var disposeBag = DisposeBag()
    var selectedDate: Date?

    init(coordinator: MainCoordinator) {
        
        self.coordinator = coordinator
    }
    
    struct Input {
        let didTapConfirmButton: Observable<Void>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        
        input.didTapConfirmButton.subscribe (onNext: { _ in
            
            print("pass")
            self.coordinator?.sendDateFromMonthlyCalender(date: self.selectedDate)
                    
        }).disposed(by: disposeBag)
        
        
        return Output()
    }
    
}
