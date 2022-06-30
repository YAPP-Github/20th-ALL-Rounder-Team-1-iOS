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
    
    let sampleData = [
        "일하기가 시작되었습니다",
        "수근수근님이 2022.05.01 장보러 가서 우유 사오기에 스티커를 붙였습니다",
        "수근수근님이 팔로우하였습니다",
        "일하기가 종료되었습니다"
    ]
    
    let disposeBag = DisposeBag()
    
    var tableViewDataSource: UITableViewDiffableDataSource<AlarmSection, String>!
    
    private var alarmList = BehaviorRelay<[String]>(value: [])
    
    init() {
        BehaviorRelay<[String]>.just(sampleData).bind(to: alarmList).disposed(by: disposeBag)
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
