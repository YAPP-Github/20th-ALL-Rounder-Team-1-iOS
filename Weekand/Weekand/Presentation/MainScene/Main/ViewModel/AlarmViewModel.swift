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
    
    var tableViewDataSource: UITableViewDiffableDataSource<AlarmSection, String>!
    
    private var alarmList = BehaviorRelay<[String]>(value: [])
    
    init(mainUseCase: MainUseCase) {
        
        self.mainUseCase = mainUseCase
        getAlarmList(page: 0, size: 20)
    }

}

// MARK: Diffable Data Source
extension AlarmViewModel {
    
    func configureTableViewSnapshot(animatingDifferences: Bool = true) {
        
        self.alarmList.subscribe(onNext: { data in
            
            var snapshot = NSDiffableDataSourceSnapshot<AlarmSection, String>()
            snapshot.appendSections([.main])
            snapshot.appendItems(data, toSection: .main)
            self.tableViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }).disposed(by: self.disposeBag)
    }

}

// MARK: Network
extension AlarmViewModel {
    
    func getAlarmList(page: Int, size: Int) {
        self.mainUseCase.notification(page: page, size: size).subscribe(onSuccess: { notifications in
            
            let data = notifications.map { $0.message }
            BehaviorRelay<[String]>.just(data).bind(to: self.alarmList).disposed(by: self.disposeBag)
            
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
}
