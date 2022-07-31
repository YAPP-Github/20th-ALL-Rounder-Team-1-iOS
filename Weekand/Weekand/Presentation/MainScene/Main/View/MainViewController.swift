//
//  MainViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/30.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxGesture
import RxCocoa

class MainViewController: UIViewController {
        
    var viewModel: MainViewModel?
    let disposeBag = DisposeBag()
    
    var currentDate: Date = Date() {
        didSet {
            headerView.calendarView.selectDate(date: currentDate)
            viewModel?.currentDate = currentDate
        }
    }
    
    // MARK: UI Properties
    var collectionView: UICollectionView!
    var headerView = MainViewHeader()
    var tableView: UITableView!
    
    lazy var foldButton = UIBarButtonItem(image: UIImage(named: "emptyImage")!, style: .plain, target: self, action: nil)
    lazy var searchButton = UIBarButtonItem(image: UIImage(named: "search") ?? UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
    lazy var alarmButton = UIBarButtonItem(image: UIImage(named: "alarm") ?? UIImage(systemName: "bell"), style: .plain, target: self, action: nil)

    lazy var floatingButton = UIButton().then {
        $0.backgroundColor = .mainColor
        $0.layer.cornerRadius = 28
        $0.setImage(UIImage(named: "category.update")?.withTintColor(.white), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    let didTapScheduleCell = PublishRelay<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.loadData()
    }
    
    private func setUpView() {
        
        self.view.backgroundColor = .backgroundColor
        configureCollectionView()
        configureTableView()
    }

    private func configureUI() {
        
        // Navigation Bar
        let foldButtonImage = UIImage(named: "chevron.up") ?? UIImage(systemName: "chevron.up")
        foldButton.setBackgroundImage(foldButtonImage?.withTintColor(.gray900), for: .normal, barMetrics: .default)
        navigationItem.leftBarButtonItem = foldButton
        navigationItem.rightBarButtonItems = [alarmButton, searchButton]
        
        // Content View
        [ collectionView, headerView, tableView ].forEach { self.view.addSubview($0) }
        collectionView.setContentHuggingPriority(.required, for: .vertical)
        collectionView.setContentCompressionResistancePriority(.required, for: .vertical)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.lessThanOrEqualTo(80)
        }
        headerView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        headerView.calendarView.delegate = self
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // floating Button
        self.view.addSubview(floatingButton)
        floatingButton.snp.makeConstraints { make in
            make.width.height.equalTo(56)
            make.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(73)
        }
        
        // MARK: Gesture
        self.headerView.calendarView.titleLabel.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                self.viewModel?.coordinator?.pushMonthlyCalendarSheet(date: self.currentDate)
            }.disposed(by: disposeBag)
        
        self.headerView.profileView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                print("Profile")
            }.disposed(by: disposeBag)
        
    }
    
    // MARK: Bind View Model
    private func bindViewModel() {
        
        let input = MainViewModel.Input(
            
            // Navigation Button
            didFoldBarButton: self.foldButton.rx.tap.asObservable(),
            didAlarmBarButton: self.alarmButton.rx.tap.asObservable(),
            didsearchBarButton: self.searchButton.rx.tap.asObservable(),
            
            didUserSummaryTap: self.headerView.profileView.rx.tapGesture().asObservable(),
            
            // Calendar Button
            didTapTodayButton: self.headerView.calendarView.todayButton.rx.tap.asObservable(),
            didTapNextWeekButton: self.headerView.calendarView.rightButton.rx.tap.asObservable(),
            didTapPrevWeekButton: self.headerView.calendarView.leftButton.rx.tap.asObservable(),
            didTapEditButton: self.headerView.calendarView.editButton.rx.tap.asObservable(),
            
            // Floating Button
            didTapFloatingButton: self.floatingButton.rx.tap.asObservable(),
            
            didTapScheduleCell: didTapScheduleCell
        )
        
        
        let output = self.viewModel?.transform(input: input)
        
        output?.calendarDate.subscribe(onNext: { data in
            self.currentDate = data
        }).disposed(by: disposeBag)
        
        output?.scrollWeek.subscribe(onNext: { data in
            self.headerView.calendarView.scrollWeek(isNext: data)
        }).disposed(by: disposeBag)
        
        output?.foldCollection.subscribe(onNext: { _ in
            self.foldCollectionView()
        }).disposed(by: disposeBag)
        
        output?.userSummary.subscribe(onNext: { data in
            self.headerView.profileView.setUpView(data)
            
            if data.userId == UserDataStorage.shared.userID {
                self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .init())
            }
        }).disposed(by: disposeBag)
        
    }

}

// MARK: CollectionView DataSource
extension MainViewController {
    
    private func configureCollectionView() {
        setUpCollectionView()
        configureCollectionViewDataSource()
    }
    
    private func setUpCollectionView() {
                
        let layout = UICollectionViewCompositionalLayout { (_: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
                        
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(40), heightDimension: .absolute(60))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(14), top: nil, trailing: .fixed(14), bottom: nil)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(0), heightDimension: .absolute(60)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = .init(top: 12, leading: 10, bottom: 12, trailing: 24)

            return section
        }
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
    }
    
    private func configureCollectionViewDataSource() {
        
        viewModel?.collectionViewDataSource = UICollectionViewDiffableDataSource<MainSection, FollowingUser>(collectionView: collectionView, cellProvider: { collectionView, indexPath, list in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as! MainCollectionViewCell
            cell.setUpCell(list)
            
            return cell
        })
        
        viewModel?.configureCollectionViewSnapShot()
    }
    
}

// MARK: CollectionViewCell Tap
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MainCollectionViewCell
        viewModel?.userChanged(id: cell.dataId)
        
        self.headerView.calendarView.editButton.isHidden = !(UserDataStorage.shared.userID == viewModel?.currentUserId)
    }
}

// MARK: Calender Selection
extension MainViewController: MainCalendarDelegate {
    func didSelectCalendar(date: Date) {
        viewModel?.dateChanged(date: date)
    }
}


// MARK: TableView DataSource
extension MainViewController {
    
    private func configureTableView() {
        setUpTableView()
        configureTableViewDataSource()
    }
    
    private func setUpTableView() {
        
        tableView = UITableView()
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 16))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 64))
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }

    }
    
    private func configureTableViewDataSource() {
        
        viewModel?.tableViewDataSource = UITableViewDiffableDataSource<MainSection, ScheduleMain>(tableView: tableView, cellProvider: { tableView, indexPath, schedule in
            let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
            
            cell.switchStickerButtonAppearance(isMine: self.viewModel?.isMySchedule)
            cell.setUpCell(schedule)
            cell.delegate = self
            
            return cell
        })
        
        viewModel?.configureTableViewSnapshot()
    }
    
}

// MARK: TableView Swipe
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let disabledAction = UISwipeActionsConfiguration().then {
            $0.performsFirstActionWithFullSwipe = false
        }
        
        let scheduleId = (tableView.cellForRow(at: indexPath) as? MainTableViewCell)?.dataId
        guard let id = scheduleId else { return disabledAction }
        if !(self.viewModel?.isMySchedule ?? true) { return disabledAction }
        
        let update = UIContextualAction(style: .normal, title: "수정") { _, _, completionHandler in
            self.viewModel?.coordinator?.showScheduleModifyScene(scheduleId: id, requestDate: self.currentDate)
            completionHandler(true)
        }
        update.backgroundColor = .mainColor
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { _, _, completionHandler in
            
            // 일반 일정인 경우
            self.showActionSheet(titles: "삭제", message: "일정를 삭제하시겠어요?") { _ in
                self.viewModel?.deleteSchedule(scheduleId: id, completion: {
                    self.viewModel?.loadData()
                })
            }
            
            // 반복 일정인 경우
//            self.showActionSheet(
//                titles: ("이 일정에만 적용", "이후 모든 일정에도 적용"),
//                message: "반복된 일정을 삭제하시겠어요?",
//                deleteHandler: { _ in
//                  // 스킵
//                }, deleteAfterHandler: { _ in
//                  // 완전 삭제
//                })
//            completionHandler(true)
        }
        delete.backgroundColor = .wred
        
        
        
        return UISwipeActionsConfiguration(actions: [delete, update])
    }
}

// MARK: TableViewCell Tap Gesture
extension MainViewController: MainTableViewCellDelegate {
    func cellTapped(id: String?, status: Status?) {
        if let scheduleId = id {
            self.didTapScheduleCell.accept(scheduleId)
        }
    }
    
    func emojiViewTapped(id: String?) {
        print("\(#function), id: \(String(describing: id))")
        
        if let scheduleId = id {
            self.viewModel?.coordinator?.pushEmojiSheet(id: scheduleId, date: currentDate)
        }
    }
    
    func stickerButtonTapped(id: String?) {
        print("\(#function), id: \(String(describing: id))")
        
        guard let id = id else { return }
        
        self.viewModel?.coordinator?.pushStickerAddSheet(id: id, date: currentDate)
    }
}

// MARK: UI Animation
extension MainViewController {
    
    /// CollectionView를 접고 펴는 함수
    private func foldCollectionView() {
        
        let isFolded = collectionView.frame.height == 0 ? true : false
        let viewHeight: CGFloat = isFolded ? 80 : 0
        let buttonImage = isFolded ? UIImage(named: "chevron.up") ?? UIImage(systemName: "chevron.up") : UIImage(named: "chevron.down") ?? UIImage(systemName: "chevron.down")
        
        collectionView.snp.updateConstraints { make in
            make.height.lessThanOrEqualTo(viewHeight)
        }
        
        if let safeImage = buttonImage {
            navigationItem.leftBarButtonItem?.setBackgroundImage(safeImage.withTintColor(.gray900), for: .normal, barMetrics: .default)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
       }
        
    }
}
