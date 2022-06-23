//
//  MainViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/04.
//

import Foundation
import RxCocoa
import RxSwift

enum MainSection {
  case main
}

class MainViewModel {
    
    weak var coordinator: MainCoordinator?
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<MainSection, FollowingUser>!
    var tableViewDataSource: UITableViewDiffableDataSource<MainSection, ScehduleMain>!
    
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

// MARK: Configure DiffableDataSource Snapshot
extension MainViewModel {
    
    func configureCollectionViewSnapShot(animatingDifferences: Bool = false) {
        
        let sample = [
            FollowingUser(userId: 0, name: "Sam", imagePath: "https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"),
            FollowingUser(userId: 0, name: "Lisa", imagePath: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"),
            FollowingUser(userId: 0, name: "James", imagePath: "https://images.unsplash.com/photo-1466112928291-0903b80a9466?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"),
            FollowingUser(userId: 0, name: "Susan", imagePath: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60"),
            FollowingUser(userId: 0, name: "Tom", imagePath: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTl8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60"),
            FollowingUser(userId: 0, name: "김수자", imagePath: "https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80"),
            FollowingUser(userId: 0, name: "여긴어디 난누구", imagePath: "https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTV8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60"),
            FollowingUser(userId: 0, name: "Sam", imagePath: "https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"),
            FollowingUser(userId: 0, name: "Lisa", imagePath: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"),
            FollowingUser(userId: 0, name: "James", imagePath: "https://images.unsplash.com/photo-1466112928291-0903b80a9466?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"),
            FollowingUser(userId: 0, name: "Susan", imagePath: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60"),
            FollowingUser(userId: 0, name: "Tom", imagePath: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTl8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60"),
            FollowingUser(userId: 0, name: "김수자", imagePath: "https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80"),
            FollowingUser(userId: 0, name: "여긴어디 난누구", imagePath: "https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTV8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60")
        ]
        
        var snapshot = NSDiffableDataSourceSnapshot<MainSection, FollowingUser>()
        snapshot.appendSections([.main])
        snapshot.appendItems(sample, toSection: .main)
        collectionViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func configureTableViewSnapshot(animatingDifferences: Bool = true) {
        
        // TODO: 샘플 데이터 정리 & 테스트 코드로 이동
        // TODO: Rx로 리팩토링
        let sample = [
            ScehduleMain(scheduleId: 0, color: "red", name: "Alfted", dateStart: Date(), dataEnd: Date(), stickerCount: 134, stickerNameList: []),
            ScehduleMain(scheduleId: 0, color: "red", name: "Timothy", dateStart: Date(), dataEnd: Date(), stickerCount: 313, stickerNameList: []),
            ScehduleMain(scheduleId: 0, color: "red", name: "Cook", dateStart: Date(), dataEnd: Date(), stickerCount: 54, stickerNameList: []),
            ScehduleMain(scheduleId: 0, color: "red", name: "Steve", dateStart: Date(), dataEnd: Date(), stickerCount: 431, stickerNameList: []),
            ScehduleMain(scheduleId: 0, color: "red", name: "Stwie", dateStart: Date(), dataEnd: Date(), stickerCount: 64, stickerNameList: []),
            ScehduleMain(scheduleId: 0, color: "red", name: "Proro", dateStart: Date(), dataEnd: Date(), stickerCount: 3, stickerNameList: []),
            ScehduleMain(scheduleId: 0, color: "red", name: "Pack", dateStart: Date(), dataEnd: Date(), stickerCount: 13, stickerNameList: []),
            ScehduleMain(scheduleId: 0, color: "red", name: "Alfted", dateStart: Date(), dataEnd: Date(), stickerCount: 134, stickerNameList: []),
            ScehduleMain(scheduleId: 0, color: "red", name: "Timothy", dateStart: Date(), dataEnd: Date(), stickerCount: 313, stickerNameList: []),
            ScehduleMain(scheduleId: 0, color: "red", name: "Cook", dateStart: Date(), dataEnd: Date(), stickerCount: 54, stickerNameList: []),
            ScehduleMain(scheduleId: 0, color: "red", name: "Steve", dateStart: Date(), dataEnd: Date(), stickerCount: 431, stickerNameList: []),
            ScehduleMain(scheduleId: 0, color: "red", name: "Stwie", dateStart: Date(), dataEnd: Date(), stickerCount: 64, stickerNameList: []),
            ScehduleMain(scheduleId: 0, color: "red", name: "Proro", dateStart: Date(), dataEnd: Date(), stickerCount: 3, stickerNameList: []),
            ScehduleMain(scheduleId: 0, color: "red", name: "Pack", dateStart: Date(), dataEnd: Date(), stickerCount: 13, stickerNameList: [])
        ]
        
        var snapshot = NSDiffableDataSourceSnapshot<MainSection, ScehduleMain>()
        snapshot.appendSections([.main])
        snapshot.appendItems(sample, toSection: .main)
        tableViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
      }

    
}
