//
//  MainViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/30.
//

import UIKit
import SnapKit
import Then

class MainViewController: UIViewController {
    
    enum Section {
      case main
    }
    
    var viewModel: MainViewModel?
    var dataSource: UITableViewDiffableDataSource<Section, ScehduleMain>!
    var headerView: MainTableViewHeader!
    
    // TODO: 하드코딩된 identifier들 삭제
    let cellId = "cell-id"
    let headerId = "header-id"
    
    lazy var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
        configureDataSource()
        configureSnapshot()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let headerView = tableView.tableHeaderView {

            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }
    }
    
    private func setUpView() {
        
        headerView = MainTableViewHeader()
    
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame.size.height = headerView.frame.size.height
        tableView.separatorStyle = .none
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: cellId)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

    private func configureUI() {
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

// MARK: DataSource
extension MainViewController {
    
    private func configureDataSource() {
        
        dataSource = UITableViewDiffableDataSource<Section, ScehduleMain>(tableView: tableView, cellProvider: { tableView, indexPath, list in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! MainTableViewCell
            cell.setUpCell(color: .red, title: list.name, status: .completed, time: "00:00 - 00:00", emojiNumber: list.stickerCount, emojiOrder: [.awesome, .cool, .good, .support])
            return cell
        })
    }
    
    private func configureSnapshot(animatingDifferences: Bool = true) {
        
        // TODO: 샘플 데이터 정리 & 테스트 코드로 이동
        let sample = [
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
