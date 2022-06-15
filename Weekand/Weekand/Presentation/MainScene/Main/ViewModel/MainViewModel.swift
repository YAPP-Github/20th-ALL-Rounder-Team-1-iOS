//
//  MainViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/04.
//

import Foundation
import RxCocoa
import RxSwift

class MainViewModel {
    
    weak var coordinator: MainCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
}

// MARK: Bind UI
extension MainViewModel {
    
    struct Input {
        // CalendarView
        let didTapTodayButtom: Observable<Void>
        let didTapNextWeekButton: Observable<Void>
        let didTapPrevWeekButton: Observable<Void>
        let didTapEditButton: Observable<Void>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.didTapEditButton.subscribe(onNext: { [weak self] _ in
            self?.coordinator?.showCategoryScene()
        }).disposed(by: disposeBag)
        
        input.didTapTodayButtom.subscribe(onNext: { _ in
            print("today")
        }).disposed(by: disposeBag)
        
        input.didTapNextWeekButton.subscribe(onNext: { _ in
            print("next week")
        }).disposed(by: disposeBag)
        
        input.didTapPrevWeekButton.subscribe(onNext: { _ in
            print("prev week")
        }).disposed(by: disposeBag)

        
        return output
    }

}
