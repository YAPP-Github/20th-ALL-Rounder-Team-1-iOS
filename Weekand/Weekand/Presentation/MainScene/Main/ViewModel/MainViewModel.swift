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
    
    private var isMyProfileAdded: Bool = false  // 내 정보가 팔로잉 CollectionView에 추가되었는지 식별
    
    // Calendar 버튼 관련 Obsrvables
    private let calendarDate = BehaviorRelay<Date>(value: Date())
    private let scrollWeek = PublishRelay<Bool>()
    private let foldCollection = PublishRelay<Void>()
    
    // 현재 일정이 나의 일정인지 식별하는 Property
    var isMySchedule: Bool = true
    var currentUserId: String?
    var currentDate: Date = Date() {
        didSet {
            self.switchDate(id: currentUserId)
        }
    }
    
    init(coordinator: MainCoordinator, mainUseCase: MainUseCase) {
        self.coordinator = coordinator
        self.mainUseCase = mainUseCase
        
        self.getFollowingUser()
        self.getUserSummary(id: nil)
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
        input.didUserSummaryTap.when(.recognized)
            .subscribe(onNext: { [weak self] _ in
            
                print("To \(self?.currentUserId ?? "") Profile")
                self?.coordinator?.showProfileScene(id: self?.currentUserId)
            
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

// MARK: User/Date Switch Actions
extension MainViewModel {
    
    /// 유저 전환
    func switchUser(id: String?) {
        
        getUserSummary(id: currentUserId)
        getScheduleList(date: currentDate)
    }
    
    /// 날짜 전환
    func switchDate(id: String?) {
        
        if isMySchedule {
            print("Get my Schedule on \(currentDate)")
            getScheduleList(date: currentDate)
        } else {
            print("Get \(String(describing: id)) Schedule on \(currentDate)")
            getScheduleList(date: currentDate) // TODO: id 소유자의 일정 불러오기
        }
    }
    
    /// id가 로그인한 유저인지 식별 후 저장
    func identifyMyPage(id: String?) {
        
        if currentUserId != id {
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
    }
    
    /// 유저 변경(CollectionView selection)이 이루어졌을때 실행되는 동작
    func userChanged(id: String?) {
        identifyMyPage(id: id)
        switchUser(id: id)
    }
    
    func dateChanged(date: Date) {
        currentDate = date
        switchDate(id: currentUserId)
    }
}

// MARK: Configure DiffableDataSource Snapshot
extension MainViewModel {
    
    func configureCollectionViewSnapShot(animatingDifferences: Bool = false) {
        
        var snapshot = NSDiffableDataSourceSnapshot<MainSection, FollowingUser>()
        snapshot.appendSections([.main])
        self.collectionViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
        // 로그인한 유저 정보 (내정보)
        self.userSummary.subscribe(onNext: { data in
            
            // 최초 1회만 실행
            if data.userId != "" && !self.isMyProfileAdded {
                var snapshot = self.collectionViewDataSource.snapshot()
                
                if let first = snapshot.itemIdentifiers.first {
                    if !(self.isMySchedule) {
                        snapshot.insertItems([FollowingUser(userSummary: data)], beforeItem: first)
                        self.collectionViewDataSource.apply(snapshot)
                    }
                } else {
                    snapshot.appendItems([FollowingUser(userSummary: data)], toSection: .main)
                    self.collectionViewDataSource.apply(snapshot)
                }
                
                UserDataStorage.shared.setUserID(id: data.userId)
                
                self.currentUserId = data.userId
                self.isMyProfileAdded = true
            }
            
        }).disposed(by: disposeBag)
        
        // 팔로잉중인 유저 정보
        self.userFollowingList.subscribe(onNext: { data in
            
            if data.count != 0 {
                var snapshot = self.collectionViewDataSource.snapshot()
                
                if let first = snapshot.itemIdentifiers.first {
                    snapshot.insertItems(data, afterItem: first)
                } else {
                    snapshot.appendItems(data, toSection: .main)
                }
                self.collectionViewDataSource.apply(snapshot)
            }
            
        }).disposed(by: disposeBag)
    }
    
    func configureTableViewSnapshot(animatingDifferences: Bool = true) {
        
        self.scheduleList.subscribe(onNext: { data in
            
            if data.count != 0 {
                var snapshot = NSDiffableDataSourceSnapshot<MainSection, ScheduleMain>()
                snapshot.appendSections([.main])
                snapshot.appendItems(data, toSection: .main)
                self.tableViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
            }
        }).disposed(by: disposeBag)
    }

}

// MARK: Network Request
extension MainViewModel {
    
    private func getFollowingUser() {
        self.mainUseCase.followers(page: 0, size: 20).subscribe(onSuccess: { following in
            PublishRelay<[FollowingUser]>.just(following).bind(to: self.userFollowingList).disposed(by: self.disposeBag)
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    private func getUserSummary(id: String?) {
        self.mainUseCase.userSummary(id: id).subscribe(onSuccess: { userData in
            
            guard let userData = userData else { return }
            
            PublishRelay<UserSummary>.just(userData).bind(to: self.userSummary).disposed(by: self.disposeBag)
            
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    private func getScheduleList(date: Date) {
        
        self.mainUseCase.scheduleList(date: date).subscribe(onSuccess: { scheduleData in
            PublishRelay<[ScheduleMain]>.just(scheduleData).bind(to: self.scheduleList).disposed(by: self.disposeBag)
            print("Schedule: \(scheduleData)")

        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
        
    }

}
