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

class MainViewController: UIViewController {
        
    var viewModel: MainViewModel?
    let disposeBag = DisposeBag()
    
    // MARK: UI Properties
    var collectionView: UICollectionView!
    var headerView = MainViewHeader()
    var tableView: UITableView!
    
    lazy var foldButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: nil)
    lazy var searchButton = UIBarButtonItem(image: UIImage(named: "search") ?? UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
    lazy var alarmButton = UIBarButtonItem(image: UIImage(named: "alarm") ?? UIImage(systemName: "bell"), style: .plain, target: self, action: nil)

    
    lazy var floatingButton = UIButton().then {
        $0.backgroundColor = .mainColor
        $0.layer.cornerRadius = 28
        $0.setImage(UIImage(named: "category.update")?.withTintColor(.white), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
        bindViewModel()
    }
    
    private func setUpView() {
        
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
                self.viewModel?.coordinator?.pushMonthlyCalendarSheet()
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
            didFoldBarButton: self.foldButton.rx.tap.asObservable() ,
            didAlarmBarButton: self.alarmButton.rx.tap.asObservable() ,
            didsearchBarButton: self.searchButton.rx.tap.asObservable() ,
            
            // Calendar Button
            didTapTodayButton: self.headerView.calendarView.todayButton.rx.tap.asObservable(),
            didTapNextWeekButton: self.headerView.calendarView.rightButton.rx.tap.asObservable(),
            didTapPrevWeekButton: self.headerView.calendarView.leftButton.rx.tap.asObservable(),
            didTapEditButton: self.headerView.calendarView.editButton.rx.tap.asObservable(),
            
            // Floating Button
            didTapFloatingButton: self.floatingButton.rx.tap.asObservable()
        )
        
        
        let output = self.viewModel?.transform(input: input)
        
        output?.calendarDate.subscribe(onNext: { data in
            self.headerView.calendarView.selectDate(date: data)
        }).disposed(by: disposeBag)
        
        output?.scrollWeek.subscribe(onNext: { data in
            self.headerView.calendarView.scrollWeek(isNext: data)
        }).disposed(by: disposeBag)
        
        output?.foldCollection.subscribe(onNext: { _ in
            self.foldCollectionView()
        }).disposed(by: disposeBag)
        
        viewModel?.userSummary.subscribe(onNext: { data in
            self.headerView.profileView.setUpView(data)
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
                
        let layout = UICollectionViewCompositionalLayout {
            (_: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
                        
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
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
    }
    
    private func configureCollectionViewDataSource() {
        
        viewModel?.collectionViewDataSource = UICollectionViewDiffableDataSource<MainSection, FollowingUser>(collectionView: collectionView, cellProvider: { collectionView, indexPath, list in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as! MainCollectionViewCell
            cell.setUpCell(list)
            
            if indexPath.item == 0 {
                self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            }
            
            return cell
        })
        
        viewModel?.configureCollectionViewSnapShot()
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
        tableView.allowsSelection = false
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 16))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 64))
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }

    }
    
    private func configureTableViewDataSource() {
        
        viewModel?.tableViewDataSource = UITableViewDiffableDataSource<MainSection, ScehduleMain>(tableView: tableView, cellProvider: { tableView, indexPath, list in
            let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
            
            cell.switchStickerButtonAppearance(userId: "123456")    // TODO: 로그인 구현 후 수정
            cell.setUpCell(id: "id: \(indexPath.row)", color: .red, title: list.name, status: .completed, time: "00:00 - 00:00", emojiNumber: list.stickerCount, emojiOrder: [.awesome, .cool, .good, .support])
            cell.delegate = self
            
            return cell
        })
        
        viewModel?.configureTableViewSnapshot()
    }
    
}

// MARK: Cell Tap Gesture
extension MainViewController: MainTableViewCellDelegate {
    func cellTapped(id: String?) {
        print("\(#function), id: \(String(describing: id))")
    }
    
    func emojiViewTapped(id: String?) {
        print("\(#function), id: \(String(describing: id))")
        self.viewModel?.coordinator?.pushEmojiSheet()
    }
    
    func stickerButtonTapped(id: String?) {
        print("\(#function), id: \(String(describing: id))")
        self.viewModel?.coordinator?.pushStickerAddSheet()
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
