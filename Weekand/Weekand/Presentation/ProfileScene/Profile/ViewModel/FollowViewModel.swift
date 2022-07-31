//
//  FollowViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/31.
//

import Foundation
import RxSwift
import RxRelay

enum FollowSection {
    case main
}

class FollowViewModel: ViewModelType {
    
    weak var coordinator: ProfileCoordinator?
    private let profileUseCase: ProfileUseCase
    private let disposeBag = DisposeBag()
    
    var type: FollowInformationType
    var id: String
    var userName: String
    
    var tableViewDataSource: UITableViewDiffableDataSource<FollowSection, UserSummaryTemp>!
    private var followList = BehaviorRelay<[UserSummaryTemp]>(value: [])

    
    init (coordinator: ProfileCoordinator, useCase: ProfileUseCase, id: String, userName: String, type: FollowInformationType) {
        self.coordinator = coordinator
        self.profileUseCase = useCase
        self.id = id
        self.userName = userName
        self.type = type
        
        switch type {
        case .followee:
            getFolloweeList(id: id, page: 0, size: 20)
            break
        case .follower:
            getFollowerList(id: id, page: 0, size: 20)
            break
        }
    }
}

extension FollowViewModel {
    
    struct Input { }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}


// MARK: Diffable Data Source
extension FollowViewModel {
    
    func configureTableViewSnapshot(animatingDifferences: Bool = true) {
        
        self.followList.subscribe(onNext: { data in
            
            var snapshot = NSDiffableDataSourceSnapshot<FollowSection, UserSummaryTemp>()
            snapshot.appendSections([.main])
            snapshot.appendItems(data, toSection: .main)
            self.tableViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }).disposed(by: self.disposeBag)
    }

}

// MARK: Network
extension FollowViewModel {
    
    func getFolloweeList(id: String, page: Int, size: Int) {
        self.profileUseCase.userFollowees(id: id, page: page, size: size).subscribe(onSuccess: { data in
            
            self.followList.accept(data)
            
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
            self.followList.accept([])
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    func getFollowerList(id: String, page: Int, size: Int) {
        self.profileUseCase.userFollowers(id: id, page: page, size: size).subscribe(onSuccess: { data in
            
            self.followList.accept(data)
            
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
            self.followList.accept([])
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
}
