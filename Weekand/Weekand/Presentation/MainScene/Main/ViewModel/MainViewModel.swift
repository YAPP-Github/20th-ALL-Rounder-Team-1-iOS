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
    
//    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, FollowingUser>!
//    var tableViewDataSource: UITableViewDiffableDataSource<Section, ScehduleMain>!
    
    private let disposeBag = DisposeBag()
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
}

// MARK: Bind UI
extension MainViewModel {
    
    struct Input {
        
        // Navigation Item
        let didFoldBarButton: Observable<Void>
        let didAlarmBarButton: Observable<Void>
        let didsearchBarButton: Observable<Void>
        
        // CalendarView
        let didTapTodayButton: Observable<Void>
        let didTapNextWeekButton: Observable<Void>
        let didTapPrevWeekButton: Observable<Void>
        let didTapEditButton: Observable<Void>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        let output = Output()
        
        // Navigation Items
        input.didFoldBarButton.subscribe(onNext: { _ in
            print("fold")
        }).disposed(by: disposeBag)
        
        input.didAlarmBarButton.subscribe(onNext: { [weak self] _ in
            self?.coordinator?.showAlarmScene()
        }).disposed(by: disposeBag)
        
        input.didsearchBarButton.subscribe(onNext: { [weak self] _ in
            self?.coordinator?.showSearchScene()
        }).disposed(by: disposeBag)
        
        // Calander Buttons
        input.didTapEditButton.subscribe(onNext: { [weak self] _ in
            self?.coordinator?.showCategoryScene()
        }).disposed(by: disposeBag)
        
        input.didTapTodayButton.subscribe(onNext: { _ in
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
