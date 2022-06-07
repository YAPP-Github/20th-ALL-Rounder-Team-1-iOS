//
//  CategoryViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/07.
//

import UIKit
import SnapKit

class CategoryViewController: UIViewController {
    
    enum Section {
      case main
    }
    
    let sample: [Category] = [
        Category(color: "red", name: "카테고리1", openType: .allOpen),
        Category(color: "red", name: "카테고리2", openType: .closed),
        Category(color: "red", name: "카테고리3", openType: .followerOpen),
        Category(color: "red", name: "카테고리4", openType: .closed),
        Category(color: "red", name: "카테고리5", openType: .allOpen),
        Category(color: "red", name: "카테고리6", openType: .allOpen),
        Category(color: "red", name: "카테고리7", openType: .closed),
        Category(color: "red", name: "카테고리8", openType: .followerOpen),
        Category(color: "red", name: "카테고리9", openType: .closed),
        Category(color: "red", name: "카테고리10", openType: .allOpen)
    ]
    
    var dataSource: UITableViewDiffableDataSource<Section, Category>!
    
    lazy var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        bindViewModel()
        configureDataSource()
        configureSnapshot()
    }
    
    private func setupView() {
        tableView.separatorStyle = .none
        tableView.register(CategoryListTableViewCell.self, forCellReuseIdentifier: CategoryListTableViewCell.cellIdentifier)
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.leading.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        
    }
}

// MARK: TableView
extension CategoryViewController {
    
    private func configureDataSource() {
        
        dataSource = UITableViewDiffableDataSource<Section, Category>(tableView: tableView, cellProvider: { tableView, indexPath, list in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryListTableViewCell.cellIdentifier, for: indexPath) as? CategoryListTableViewCell else {
                return UITableViewCell()
            }
            cell.accessoryType = .disclosureIndicator
            cell.configure(color: UIColor(hex: "#FFC8C8") ?? .red, openType: list.openType, name: list.name)
            return cell
        })
    }
    
    private func configureSnapshot(animatingDifferences: Bool = true) {

        var snapshot = NSDiffableDataSourceSnapshot<Section, Category>()
        snapshot.appendSections([.main])
        snapshot.appendItems(sample, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
}

import SwiftUI
#if canImport(SwiftUI) && DEBUG

struct CategoryViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            CategoryViewController().showPreview(.iPhone11Pro)
        }
    }
}
#endif
