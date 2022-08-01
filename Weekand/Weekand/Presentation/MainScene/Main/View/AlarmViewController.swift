//
//  AlarmViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/29.
//

import UIKit
import RxSwift

class AlarmViewController: UIViewController {
    
    var viewModel: AlarmViewModel?
    let disposeBag = DisposeBag()
    
    var tableView: UITableView!
    var refreshListCount: Int = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
        bindViewModel()
    }
    
    
    private func setUpView() {
        self.title = "알림"
        
        configureTableView()
    }
    
    private func configureUI() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        
    }
}

// MARK: TableView DataSource
extension AlarmViewController {
    
    private func configureTableView() {
        setUpTableView()
        configureTableViewDataSource()
    }
    
    private func setUpTableView() {
        
        tableView = UITableView()
        tableView.register(AlarmTableViewCell.self, forCellReuseIdentifier: AlarmTableViewCell.identifier)
        tableView.delegate = self
        tableView.backgroundView = WEmptyView(type: .alarm)
        tableView.backgroundView?.isHidden = true
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
            
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }

    }
    
    private func configureTableViewDataSource() {
        
        viewModel?.tableViewDataSource = UITableViewDiffableDataSource<AlarmSection, Alarm>(tableView: tableView, cellProvider: { tableView, indexPath, alarm in
            let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.identifier, for: indexPath) as! AlarmTableViewCell
            cell.setUpCell(description: alarm.message)
            return cell
        })
        
        let snapshot = viewModel?.tableViewDataSource.snapshot()
        if snapshot?.itemIdentifiers.isEmpty ?? true {
            self.tableView.backgroundView?.isHidden = false
        }
        
        viewModel?.configureTableViewSnapshot()
    }
    
}

extension AlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let currentPage = viewModel?.page else { return }
        
        if indexPath.item == refreshListCount * (currentPage + 1) - 1 {
            self.viewModel?.loadMoreAlarmList()
        }
    }
}
