//
//  AlarmViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/29.
//

import UIKit
import RxSwift
import RxRelay

enum AlarmSection {
    case main
}

class AlarmViewModel {

    
    private let mainUseCase: MainUseCase
    let disposeBag = DisposeBag()
    
    var tableViewDataSource: UITableViewDiffableDataSource<AlarmSection, Alarm>!
    
    private var alarmList = BehaviorRelay<[Alarm]>(value: [])
    var toggleEmptyView = BehaviorRelay<Bool>(value: false)
    var page = 0
    var hasNext = false
    
    init(mainUseCase: MainUseCase) {
        
        self.mainUseCase = mainUseCase
        getAlarmList(page: 0, size: 20)
    }

}

// MARK: Diffable Data Source
extension AlarmViewModel {
    
    func configureTableViewSnapshot(animatingDifferences: Bool = true) {
        
        var snapshot = NSDiffableDataSourceSnapshot<AlarmSection, Alarm>()
        snapshot.appendSections([.main])
        self.tableViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
        self.alarmList.subscribe(onNext: { data in
            
            var snapshot = self.tableViewDataSource.snapshot()
            if let last = snapshot.itemIdentifiers.last {
                snapshot.insertItems(data, afterItem: last)
            } else {
                snapshot.appendItems(data, toSection: .main)
            }
            
            self.tableViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
            
        }).disposed(by: self.disposeBag)
    }

}

// MARK: Network
extension AlarmViewModel {
    
    func getAlarmList(page: Int, size: Int) {
        self.mainUseCase.notification(page: page, size: size).subscribe(onSuccess: { data in
            
            self.alarmList.accept(data.notifications.map { Alarm(model: $0) })
            self.hasNext = data.paginationInfo.hasNext
            
            self.toggleEmptyView.accept(data.notifications.isEmpty)
            
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    func loadMoreAlarmList() {
        print("Try load more | Current: \(page) | hasNest: \(hasNext)")
        if hasNext {
            self.page += 1
            self.getAlarmList(page: self.page, size: 20)
        }
    }

}
