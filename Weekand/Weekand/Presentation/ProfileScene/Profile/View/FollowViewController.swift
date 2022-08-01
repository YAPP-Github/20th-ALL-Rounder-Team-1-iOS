//
//  FollowViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/31.
//

import Foundation
import RxSwift
import SnapKit
import Then
import UIKit

class FollowViewController: UIViewController {
    
    var viewModel: FollowViewModel?
    private let disposeBag = DisposeBag()
    
    var tableView: UITableView!
    var requestListCount: Int = 20
    var refreshListCount: Int = 15
    
    lazy var nameLabel = UILabel().then {
        $0.font = WFont.head2()
        $0.textColor = .mainColor
        $0.textAlignment = .right
    }
    lazy var suffixLabel = UILabel().then {
        $0.font = WFont.head2()
        $0.textColor = .gray900
        $0.textAlignment = .left
    }
    lazy var labelStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 0
        
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 32, left: 24, bottom: 16, right: 24)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
        bindViewModel()
    }
    
    private func setUpView() {
        self.view.backgroundColor = .backgroundColor
        self.title = viewModel?.type.rawValue
        self.nameLabel.text = viewModel?.userName
        self.suffixLabel.text = viewModel?.type.descriptionSuffix
        
        configureTableView()
    }
    
    private func configureUI() {
        [nameLabel, suffixLabel].forEach { labelStack.addArrangedSubview($0) }
        nameLabel.setContentHuggingPriority(.required, for: .horizontal)
        [labelStack, tableView].forEach { self.view.addSubview($0) }
        labelStack.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(labelStack.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        
    }
}

// MARK: TableView Configuration
extension FollowViewController {
    private func configureTableView() {
        setUpTableView()
        configureTableViewDataSource()
    }
    
    private func setUpTableView() {
        
        tableView = UITableView()
        tableView.register(FollowTableViewCell.self, forCellReuseIdentifier: FollowTableViewCell.cellIdentifier)
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        
        let emptyView = viewModel?.type == .followee ? WEmptyView(type: .following) : WEmptyView(type: .follower)
        tableView.backgroundView = emptyView
        tableView.backgroundView?.isHidden = false
            
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }

    }
    
    private func configureTableViewDataSource() {
        
        viewModel?.tableViewDataSource = UITableViewDiffableDataSource<FollowSection, UserSummaryTemp>(tableView: tableView, cellProvider: { tableView, indexPath, list in
            let cell = tableView.dequeueReusableCell(withIdentifier: FollowTableViewCell.cellIdentifier, for: indexPath) as! FollowTableViewCell
            
            cell.setData(user: list)
            
            return cell
        })
        
        let snapshot = viewModel?.tableViewDataSource.snapshot()
        if snapshot?.itemIdentifiers.isEmpty ?? true {
            self.tableView.backgroundView?.isHidden = false
        }
        
        viewModel?.configureTableViewSnapshot()
    }
}

// MARK: TableView Delegate
extension FollowViewController: UITableViewDelegate {
    
    // Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let id = (tableView.cellForRow(at: indexPath) as? FollowTableViewCell)?.dataId {
            self.viewModel?.coordinator?.showProfileScene(id: id)
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
    }
    
    // Swipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 스와이프 비활성화 Action
        let disabledAction = UISwipeActionsConfiguration().then {
            $0.performsFirstActionWithFullSwipe = false
        }
        guard let userId = (tableView.cellForRow(at: indexPath) as? FollowTableViewCell)?.dataId else { return disabledAction }
        if ((viewModel?.id) != nil) != (UserDataStorage.shared.userID != nil) { return disabledAction }
        if self.viewModel?.type == .followee { return disabledAction}
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { _, _, completionHandler in
            self.viewModel?.deleteFollower(userId: userId, completion: {
                self.viewModel?.getFollowList(page: 0, size: 20)
            })
        }
        delete.backgroundColor = .wred
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    // Pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let currentPage = viewModel?.page else { return }
        
        if indexPath.item == refreshListCount * (currentPage + 1) - 1 {
            self.viewModel?.loadMoreFollowList()
        }
    }

}
