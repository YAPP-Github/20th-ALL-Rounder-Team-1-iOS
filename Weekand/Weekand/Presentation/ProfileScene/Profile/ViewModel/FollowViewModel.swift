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

class FollowViewModel {
    
    weak var coordinator: ProfileCoordinator?
    private let profileUseCase: ProfileUseCase
    private let disposeBag = DisposeBag()
    
    var type: FollowInformationType
    var id: String
    var userName: String
    
    var tableViewDataSource: UITableViewDiffableDataSource<FollowSection, UserSummaryTemp>!
    private var followList = BehaviorRelay<[UserSummaryTemp]>(value: [])
    var toggleEmptyView = BehaviorRelay<Bool>(value: false)
    var alertMessage = PublishRelay<String>()

    var page = 0
    var hasNext = false
    
    init (coordinator: ProfileCoordinator, useCase: ProfileUseCase, id: String, userName: String, type: FollowInformationType) {
        self.coordinator = coordinator
        self.profileUseCase = useCase
        self.id = id
        self.userName = userName
        self.type = type
        
        getFollowList(page: 0, size: 20)
        
    }
}

extension FollowViewModel {
    
    func getFollowList(page: Int, size: Int) {
        
        switch self.type {
        case .followee: getFolloweeList(id: id, page: page, size: size)
        case .follower: getFollowerList(id: id, page: page, size: size)
        }
    }
    
}


// MARK: Diffable Data Source
extension FollowViewModel {
    
    func configureTableViewSnapshot(animatingDifferences: Bool = false) {
        
        var snapshot = NSDiffableDataSourceSnapshot<FollowSection, UserSummaryTemp>()
        snapshot.appendSections([.main])
        self.tableViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
        self.followList.subscribe(onNext: { data in
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
extension FollowViewModel {
    
    func getFolloweeList(id: String, page: Int, size: Int) {
        self.profileUseCase.userFollowees(id: id, page: page, size: size).subscribe(onSuccess: { data in
            
            self.followList.accept(data.followees.map { UserSummaryTemp(model: $0) })
            self.hasNext = data.paginationInfo?.hasNext ?? false
            self.toggleEmptyView.accept(data.followees.isEmpty)
            
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
            self.alertMessage.accept("팔로잉 목록을 불러오지 못했습니다.")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    func getFollowerList(id: String, page: Int, size: Int) {
        self.profileUseCase.userFollowers(id: id, page: page, size: size).subscribe(onSuccess: { data in
            
            self.followList.accept(data.followers.map { UserSummaryTemp(model: $0) })
            self.hasNext = data.paginationInfo?.hasNext ?? false
            self.toggleEmptyView.accept(data.followers.isEmpty)
            
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
            self.alertMessage.accept("팔로우 목록을 불러오지 못했습니다.")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    func deleteFollower(userId: String, completion: @escaping () -> Void) {
        self.profileUseCase.deleteFollower(id: userId).subscribe(onSuccess: { isSucceed in
                if isSucceed {
                    completion()
                } else {
                    print("\(#function) Error: error")
                }
            }, onFailure: { error in
                print("\(#function) Error: \(error)")
                self.alertMessage.accept("팔로워 삭제 실패.")
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func loadMoreFollowList() {
        print("Try load more | Current: \(page) | hasNest: \(hasNext)")
        if hasNext {
            self.page += 1
            self.getFollowList(page: page, size: 20)
        }
    }

}
