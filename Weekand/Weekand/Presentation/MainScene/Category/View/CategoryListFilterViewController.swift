//
//  CategoryListFilterViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/27.
//

import UIKit
import SnapKit
import Then
import RxSwift

class CategoryListFilterViewController: BottomSheetViewController {
    
    // TableView
    
    enum Section {
      case main
    }
    
    let tableView = UITableView()
    var dataSource: UITableViewDiffableDataSource<Section, Sort>!
    
    // ViewMoel
    
    private let disposeBag = DisposeBag()
    var viewModel: CategoryListFilterViewModel?
    
    // SheetHeight
    
    override var bottomSheetHeight: CGFloat {
        get {
            return 270
        }
    }
    
    // stored property
    
    var selectedSort: Sort = .dateCreatedASC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        bindViewModel()
        configureDataSource()
        configureSnapshot()
    }
    
    private func setupView() {
        self.tableView.isScrollEnabled = false
        self.tableView.allowsMultipleSelection = false
        self.tableView.separatorStyle = .none
        self.tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.cellIdentifier)
    }
    
    private func configureUI() {
        
        bottomSheetView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(30)
        }
    }
    
    private func bindViewModel() {
        let input = CategoryListFilterViewModel.Input()
        
        self.viewModel?.transform(input: input)
    }

}

// MARK: TableView
extension CategoryListFilterViewController {
    
    private func configureDataSource() {
        
        dataSource = UITableViewDiffableDataSource<Section, Sort>(tableView: tableView, cellProvider: { tableView, indexPath, list in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.cellIdentifier, for: indexPath) as? FilterTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(text: list.description)
            return cell
        })
    }
    
    private func configureSnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Sort>()
        snapshot.appendSections([.main])
        snapshot.appendItems((Sort.allCases), toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
