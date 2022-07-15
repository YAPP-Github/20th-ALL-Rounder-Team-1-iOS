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

class MainViewModel: ViewModelType {
    
    // TODO: Service 구현 후 삭제 or 이동

    let sampleUserFollowingList = [
        FollowingUser(userId: "12345", name: "Sam", imagePath: "https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"),
        FollowingUser(userId: "0", name: "Lisa", imagePath: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"),
        FollowingUser(userId: "0", name: "James", imagePath: "https://images.unsplash.com/photo-1466112928291-0903b80a9466?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"),
        FollowingUser(userId: "0", name: "Susan", imagePath: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60"),
        FollowingUser(userId: "0", name: "Tom", imagePath: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTl8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60"),
        FollowingUser(userId: "0", name: "김수자", imagePath: "https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80"),
        FollowingUser(userId: "0", name: "여긴어디 난누구", imagePath: "https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTV8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60"),
        FollowingUser(userId: "0", name: "Sam", imagePath: "https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"),
        FollowingUser(userId: "0", name: "Lisa", imagePath: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"),
        FollowingUser(userId: "0", name: "James", imagePath: "https://images.unsplash.com/photo-1466112928291-0903b80a9466?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"),
        FollowingUser(userId: "0", name: "Susan", imagePath: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60"),
        FollowingUser(userId: "0", name: "Tom", imagePath: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTl8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60"),
        FollowingUser(userId: "0", name: "김수자", imagePath: "https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80"),
        FollowingUser(userId: "0", name: "여긴어디 난누구", imagePath: "https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTV8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60")
    ]
    
    weak var coordinator: MainCoordinator?
    private let mainUseCase: MainUseCase
    private let disposeBag = DisposeBag()
    
    // Diffable Data Source
    var collectionViewDataSource: UICollectionViewDiffableDataSource<MainSection, FollowingUser>!
    var tableViewDataSource: UITableViewDiffableDataSource<MainSection, ScheduleMain>!
    
    // View와 바인딩되는 Observables
    public var userSummary = BehaviorRelay<UserSummary>(value: UserSummary.defaultData)
    private var userFollowingList = BehaviorRelay<[FollowingUser]>(value: [])
    private var scheduleList = BehaviorRelay<[ScheduleMain]>(value: [])
    
    // Calendar 버튼 관련 Obsrvables
    private let calendarDate = BehaviorRelay<Date>(value: Date())
    private let scrollWeek = PublishRelay<Bool>()
    private let foldCollection = PublishRelay<Void>()
    
    init(coordinator: MainCoordinator, mainUseCase: MainUseCase) {
        self.coordinator = coordinator
        self.mainUseCase = mainUseCase
        
        self.getUserSummary()
        
        self.getScheduleList(date: "1656255168388".fromStringTimestamp())   // TODO: 500 에러 수정
        
        // TODO: Service 구현 후 데이터 받는 부분 이동
        PublishRelay<[FollowingUser]>.just(sampleUserFollowingList).bind(to: userFollowingList).disposed(by: disposeBag)
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
        
        // Floating Button
        let didTapFloatingButton: Observable<Void>
    }
    
    struct Output {
        let calendarDate: Observable<Date>
        let scrollWeek: Observable<Bool>
        let foldCollection: Observable<Void>
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        // Navigation Items
        input.didFoldBarButton.subscribe(onNext: { _ in
            PublishRelay<Void>.just(Void()).bind(to: self.foldCollection).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        input.didAlarmBarButton.subscribe(onNext: { [weak self] _ in
            self?.coordinator?.pushAlarmViewController()
        }).disposed(by: disposeBag)
        
        input.didsearchBarButton.subscribe(onNext: { [weak self] _ in
            self?.coordinator?.showSearchScene()
        }).disposed(by: disposeBag)
        
        // Calander Buttons
        input.didTapEditButton.subscribe(onNext: { [weak self] _ in
            self?.coordinator?.showCategoryScene()
        }).disposed(by: disposeBag)
        
        input.didTapTodayButton.subscribe(onNext: { _ in
            BehaviorRelay<Date>.just(Date()).bind(to: self.calendarDate).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        input.didTapNextWeekButton.subscribe(onNext: { _ in
            PublishRelay<Bool>.just(true).bind(to: self.scrollWeek).disposed(by: self.disposeBag)

        }).disposed(by: disposeBag)
        
        input.didTapPrevWeekButton.subscribe(onNext: { _ in
            PublishRelay<Bool>.just(false).bind(to: self.scrollWeek).disposed(by: self.disposeBag)

        }).disposed(by: disposeBag)
        
        input.didTapFloatingButton.subscribe(onNext: { _ in
            self.coordinator?.showEditScene()
        }).disposed(by: disposeBag)
        
        return Output(
            calendarDate: calendarDate.asObservable(),
            scrollWeek: scrollWeek.asObservable(),
            foldCollection: foldCollection.asObservable()
        )
    }

}

// MARK: Configure DiffableDataSource Snapshot
extension MainViewModel {
    
    func configureCollectionViewSnapShot(animatingDifferences: Bool = false) {
        
        self.userFollowingList.subscribe(onNext: { data in
            
            var snapshot = NSDiffableDataSourceSnapshot<MainSection, FollowingUser>()
            snapshot.appendSections([.main])
            snapshot.appendItems(data, toSection: .main)
            self.collectionViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }).disposed(by: disposeBag)
        
    }
    
    func configureTableViewSnapshot(animatingDifferences: Bool = true) {
        
        self.scheduleList.subscribe(onNext: { data in
            
            var snapshot = NSDiffableDataSourceSnapshot<MainSection, ScheduleMain>()
            snapshot.appendSections([.main])
            snapshot.appendItems(data, toSection: .main)
            self.tableViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }).disposed(by: disposeBag)
    }

}

// MARK: Network Request
extension MainViewModel {
    
    private func getUserSummary() {
        self.mainUseCase.userSummary().subscribe(onSuccess: { userData in
            PublishRelay<UserSummary>.just(userData).bind(to: self.userSummary).disposed(by: self.disposeBag)
        }, onFailure: { error in
            print("Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    private func getScheduleList(date: Date) {
        
        self.mainUseCase.scheduleList(date: date).subscribe (onSuccess: { scheduleData in
            PublishRelay<[ScheduleMain]>.just(scheduleData).bind(to: self.scheduleList).disposed(by: self.disposeBag)
            print(scheduleData)

        }, onFailure: { error in
            print("Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
        
    }

}
