//
//  EmojiTableViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/12.
//

import UIKit

class EmojiTableViewController: UIViewController {
    
    var viewModel: EmojiTableViewModel? {
        didSet {
            configureTableViewDataSource()
        }
    }
    
    var tableView: UITableView!
    
    init(emoji: Emoji?) {
        super.init(nibName: nil, bundle: nil)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureUI()
    }
        
    private func setUpView() {
        configureTableView()
    }
    
    private func configureUI() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}

// MARK: TableView DataSource
extension EmojiTableViewController {
    
    func configureTableView() {
        setUpTableView()
        configureTableViewDataSource()
    }
    
    private func setUpTableView() {
        
        tableView = UITableView()
        tableView.register(EmojiTableViewCell.self, forCellReuseIdentifier: EmojiTableViewCell.identifier)
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
            
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }

    }
    
    private func configureTableViewDataSource() {
        
        viewModel?.tableViewDataSource = UITableViewDiffableDataSource<EmojiSection, EmojiGiver>(tableView: tableView, cellProvider: { tableView, indexPath, list in
            let cell = tableView.dequeueReusableCell(withIdentifier: EmojiTableViewCell.identifier, for: indexPath) as! EmojiTableViewCell
            
            cell.setUpCell(list)
            
            return cell
        })
        
        viewModel?.configureTableViewSnapshot()
    }
    
}
