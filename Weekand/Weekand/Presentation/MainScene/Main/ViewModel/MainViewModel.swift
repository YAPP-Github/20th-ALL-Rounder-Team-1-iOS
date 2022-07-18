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
    
    // 현재 일정이 나의 일정인지 식별하는 Property
    var isMySchedule: Bool = true
    var currentUserId: String?
    var currentDate: Date = Date()
    
    init(coordinator: MainCoordinator, mainUseCase: MainUseCase) {
        self.coordinator = coordinator
        self.mainUseCase = mainUseCase
        
        self.getUserSummary()
        self.getFollowingUser()
        self.getScheduleList(date: currentDate)
    }
    
}

// MARK: Bind UI
extension MainViewModel {
    
    struct Input {
        
        // Navigation Item
        let didFoldBarButton: Observable<Void>
        let didAlarmBarButton: Observable<Void>
        let didsearchBarButton: Observable<Void>
        
        // UserSummary
        let didUserSummaryTap: Observable<UITapGestureRecognizer>
        
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
        
        let userSummary: Observable<UserSummary>
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
        
        // UserSummary
        input.didUserSummaryTap.subscribe(onNext: { [weak self] _ in
            
            if self?.isMySchedule ?? true {
                print("To my Profile")
                // TODO: 내 프로필로 이동
            } else {
                print("To \(self?.currentUserId ?? "") Profile")
                // TODO: 남의 프로필로 이동
            }
            
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
            foldCollection: foldCollection.asObservable(),
            userSummary: userSummary.asObservable()
        )
    }

}

extension MainViewModel {
    
    func switchUser(id: String?) {
        identifyMyPage(id: id)
        currentUserId = id
    }
    
    /// id가 로그인한 유저인지 식별 후 저장
    func identifyMyPage(id: String?) {
        
        currentUserId = id
        
        guard let id = id else {
            print("Error: id Not Found")
            return
        }
        
        if id == UserDataStorage.shared.userID {
            self.isMySchedule = true
        } else {
            self.isMySchedule = false
        }
        
        print("My Schedule: \(self.isMySchedule)")
    }
    
    /// 데이터 불러오기
    func reloadData() {
        
        if isMySchedule {
            self.getUserSummary()
            self.getScheduleList(date: "1656255168388".fromStringTimestamp())   // TODO: 500 에러 수정
        } else {
            guard let id = currentUserId else { return }
            // TODO: 선택된 유저의 UserSummary 가져오기
            // TODO: 선택된 유저의 ScheduleMain 가져오기
        }
    }
}

// MARK: Configure DiffableDataSource Snapshot
extension MainViewModel {
    
    func configureCollectionViewSnapShot(animatingDifferences: Bool = false) {
        
        // 로그인한 유저 정보 (내정보)
        self.userSummary.subscribe(onNext: { data in
            var snapshot = self.collectionViewDataSource.snapshot()
            
            if let first = snapshot.itemIdentifiers.first {
                snapshot.insertItems([FollowingUser(userSummary: data)], beforeItem: first)
            }
            self.collectionViewDataSource.apply(snapshot)
            
        }).disposed(by: disposeBag)
        
        // 팔로잉중인 유저 정보
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
    
    private func getFollowingUser() {
        self.mainUseCase.followers(page: 0, size: 20).subscribe(onSuccess: { following in
            PublishRelay<[FollowingUser]>.just(following).bind(to: self.userFollowingList).disposed(by: self.disposeBag)
        }, onFailure: { error in
            print("Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
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
