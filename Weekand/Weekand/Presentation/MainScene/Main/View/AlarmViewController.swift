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
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
         
            
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }

    }
    
    private func configureTableViewDataSource() {
        
        viewModel?.tableViewDataSource = UITableViewDiffableDataSource<AlarmSection, String>(tableView: tableView, cellProvider: { tableView, indexPath, list in
            let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.identifier, for: indexPath) as! AlarmTableViewCell
            cell.setUpCell(description: list)
            return cell
        })
        
        viewModel?.configureTableViewSnapshot()
    }
    
}
