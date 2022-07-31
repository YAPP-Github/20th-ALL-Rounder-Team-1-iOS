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
    
    var tableView: UITableView!
    
    
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
        
        viewModel?.configureTableViewSnapshot()
    }
}

extension FollowViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = (tableView.cellForRow(at: indexPath) as? FollowTableViewCell)?.dataId {
            self.viewModel?.coordinator?.showProfileScene(id: id)
        }
    }
}
