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
    
    // pagination info
    var page = 0
    var hasNext = false
    
    // Diffable Data Source
    var collectionViewDataSource: UICollectionViewDiffableDataSource<MainSection, FollowingUser>!
    var tableViewDataSource: MainScheduleDataSource!
    
    // View와 바인딩되는 Observables
    public var userSummary = BehaviorRelay<UserSummary>(value: UserSummary.defaultData)
    public var myUserSummary = BehaviorRelay<UserSummary>(value: UserSummary.defaultData)
    private var userFollowingList = BehaviorRelay<[FollowingUser]>(value: [])
    private var scheduleList = BehaviorRelay<[ScheduleMain]>(value: [])
    private var toggleEmptyView = BehaviorRelay<(Bool, Bool)>(value: (false, false))
    
    private var isMyProfileAdded: Bool = false  // 내 정보가 팔로잉 CollectionView에 추가되었는지 식별
    
    // Pagination Info
    var collectionViewHasNext: Bool = false
    var tableViewHasNext: Bool = false
    
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
                
        
    }
    
    func loadData() {
        
        self.resetCollectionViewSnapshot()
        
        self.getMyUserSummary()
        self.getFollowingUser(page: page, size: 20)
        self.getUserSummary(id: currentUserId)
        self.getScheduleList(date: currentDate, id: currentUserId)
    }
    
    private func resetCollectionViewSnapshot(animatingDifferences: Bool = false) {
        
        var snapshot = NSDiffableDataSourceSnapshot<MainSection, FollowingUser>()
        snapshot.appendSections([.main])
        snapshot.appendItems([])
        self.collectionViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
        isMyProfileAdded = false
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
        
        // CelltTap
        let didTapScheduleCell: PublishRelay<(String, Status)>
    }
    
    struct Output {
        let calendarDate: Observable<Date>
        let scrollWeek: Observable<Bool>
        let foldCollection: Observable<Void>
        let toggleEmptyView: Observable<(Bool, Bool)>
        
        let userSummary: Observable<UserSummary>
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        // Navigation Items
        input.didFoldBarButton.subscribe(onNext: { _ in
            self.foldCollection.accept(())
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
            self.calendarDate.accept(Date())
        }).disposed(by: disposeBag)
        
        input.didTapNextWeekButton.subscribe(onNext: { _ in
            self.scrollWeek.accept(true)
        }).disposed(by: disposeBag)
        
        input.didTapPrevWeekButton.subscribe(onNext: { _ in
            self.scrollWeek.accept(false)
        }).disposed(by: disposeBag)
        
        input.didTapFloatingButton.subscribe(onNext: { _ in
            self.coordinator?.showScheduleAddScene(requestDate: self.currentDate)
        }).disposed(by: disposeBag)
        
        input.didTapScheduleCell.subscribe(onNext: { (scheduleId, schduleStatus) in
            if self.isMySchedule {
                self.coordinator?.showScheduleDetailScene(scheduleId: scheduleId,
                                                          schduleStatus: schduleStatus,
                                                          requestDate: self.currentDate)
            } else {
                self.coordinator?.showFollowerScheduleDetail(scheduleId: scheduleId,
                                                             requestDate: self.currentDate)
            }
        }).disposed(by: disposeBag)
        
        return Output(
            calendarDate: calendarDate.asObservable(),
            scrollWeek: scrollWeek.asObservable(),
            foldCollection: foldCollection.asObservable(),
            toggleEmptyView: toggleEmptyView.asObservable(),
            userSummary: userSummary.asObservable()
        )
    }

}

// MARK: User/Date Switch Actions
extension MainViewModel {
    
    /// 새로고침
    func reloadData() {
        
        guard let id = currentUserId else { return }
        switchUser(id: id)
    }
    
    /// 유저 전환
    func switchUser(id: String?) {
        
        getUserSummary(id: currentUserId)
        getScheduleList(date: currentDate, id: id)
    }
    
    /// 날짜 전환
    func switchDate(id: String?) {
        
        getScheduleList(date: currentDate, id: id)
        
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
        self.myUserSummary.subscribe(onNext: { data in
            
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
                
                if self.currentUserId == nil {
                    self.currentUserId = data.userId
                }
                
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
                self.collectionViewDataSource.apply(snapshot, animatingDifferences: false, completion: nil)
            }
            
        }).disposed(by: disposeBag)
    }
    
    
    func configureTableViewSnapshot(animatingDifferences: Bool = false) {
        
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
    
    /// 팔로우하는 사람 목록
    private func getFollowingUser(page: Int, size: Int) {
        self.mainUseCase.followees(page: page, size: size).subscribe(onSuccess: { following in
            
            self.userFollowingList.accept(following.followees.map { FollowingUser(model: $0) })
            self.hasNext = following.paginationInfo?.hasNext ?? false
            
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    func loadMoreFollowingUser() {
        print("Try load more | Current: \(page) | hasNest: \(hasNext)")
        if hasNext {
            self.page += 1
            self.getFollowingUser(page: page, size: 20)
        }
    }
    
    /// 팔로잉 리스트에 본인 프로필을 올리기 위한 작업
    private func getMyUserSummary() {
        self.mainUseCase.userSummary(id: nil).subscribe(onSuccess: { userData in
            
            guard let userData = userData else { return }
            
            PublishRelay<UserSummary>.just(userData).bind(to: self.myUserSummary).disposed(by: self.disposeBag)
            
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    /// 특정 유저 정보 (이름, 사진, 목표)
    private func getUserSummary(id: String?) {
        self.mainUseCase.userSummary(id: id).subscribe(onSuccess: { userData in
            
            guard let userData = userData else { return }
            
            PublishRelay<UserSummary>.just(userData).bind(to: self.userSummary).disposed(by: self.disposeBag)
            
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    /// 특정 유저의 일정
    private func getScheduleList(date: Date, id: String?) {
        
        self.mainUseCase.scheduleList(date: date, id: id).subscribe(onSuccess: { data in
            
            self.tableViewHasNext = data.paginationInfo.hasNext
            self.scheduleList.accept(data.schedules.map { ScheduleMain.init(model: $0) })
            
            self.toggleEmptyView.accept((self.isMySchedule, data.schedules.isEmpty))

        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
        
    }

    // MARK: Schedule Editing
    func deleteSchedule(scheduleId: String, completion: @escaping () -> Void) {
        self.mainUseCase.deleteSchedule(scheduleId: scheduleId)
            .subscribe(onSuccess: { isSucceed in
                if isSucceed {
                    completion()
                } else {
                    print("\(#function) Error: error")
                }
            }, onFailure: { error in
                print("\(#function) Error: \(error)")
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func deleteScheduleFromDate(scheduleId: String, requestDate: Date, completion: @escaping () -> Void) {
        self.mainUseCase.deleteScheduleFromDate(scheduleId: scheduleId, requestDate: requestDate)
            .subscribe(onSuccess: { isSucceed in
                if isSucceed {
                    completion()
                } else {
                    print("\(#function) Error: error")
                }
            }, onFailure: { error in
                print("\(#function) Error: \(error)")
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func skipSchedule(scheduleId: String, requestDate: Date, completion: @escaping () -> Void) {
        self.mainUseCase.skipSchedule(scheduleId: scheduleId, requestDate: requestDate)
            .subscribe(onSuccess: { isSucceed in
                if isSucceed {
                    completion()
                } else {
                    print("\(#function) Error: error")
                }
            }, onFailure: { error in
                print("\(#function) Error: \(error)")
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }

}
