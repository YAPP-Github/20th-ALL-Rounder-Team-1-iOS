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
import RxCocoa

class MainViewController: UIViewController {
    
    enum Section {
      case main
    }
    
    var viewModel: MainViewModel?
    var dataSource: UITableViewDiffableDataSource<Section, ScehduleMain>!
    
    // MARK: UI Properties    
    lazy var collectionView = UICollectionView()
    lazy var headerView = MainViewHeader()
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        
        $0.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 16))
        $0.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 64))
        
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
        configureTableView()
        bindViewModel()
    }
    
    private func setUpView() {
        
        // TODO: 삭제
        headerView.profileView.setUpView(name: "이건두", state: "We can do, Week and!", profileImagePath: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80")
    }

    private func configureUI() {
        
        [ headerView, tableView ].forEach { self.view.addSubview($0) }
        headerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        let input = MainViewModel.Input(
            didTapTodayButtom: self.headerView.calendarView.todayButton.rx.tap.asObservable(),
            didTapNextWeekButton: self.headerView.calendarView.rightButton.rx.tap.asObservable(),
            didTapPrevWeekButton: self.headerView.calendarView.leftButton.rx.tap.asObservable(),
            didTapEditButton: self.headerView.calendarView.editButton.rx.tap.asObservable()
        )
        self.viewModel?.transform(input: input)
    }

}

// MARK: CollectionView DataSource
extension MainViewController {
    
    private func configureCollectionView() {
        
    }
    
    
}

// MARK: TableView DataSource
extension MainViewController {
    
    private func configureTableView() {
        configureTableViewDataSource()
        configureTableViewSnapshot()
    }
    
    private func configureTableViewDataSource() {
        
        dataSource = UITableViewDiffableDataSource<Section, ScehduleMain>(tableView: tableView, cellProvider: { tableView, indexPath, list in
            let cell = tableView.dequeueReusableCell(withIdentifier:MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
            cell.setUpCell(color: .red, title: list.name, status: .completed, time: "00:00 - 00:00", emojiNumber: list.stickerCount, emojiOrder: [.awesome, .cool, .good, .support])
            return cell
        })
    }
    
    private func configureTableViewSnapshot(animatingDifferences: Bool = true) {
        
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
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ScehduleMain>()
        snapshot.appendSections([.main])
        snapshot.appendItems(sample, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
      }

}
