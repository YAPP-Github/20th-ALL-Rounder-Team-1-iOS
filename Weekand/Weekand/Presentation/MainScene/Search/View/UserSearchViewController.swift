//
//  UserSearchViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/15.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import DropDown

class UserSearchViewController: UIViewController {

    enum Section {
      case main
    }
    
    private let disposeBag = DisposeBag()
    var viewModel: UserSearchViewModel?
    var dataSource: UITableViewDiffableDataSource<Section, UserSummaryTemp>!
    
    var headerView = SearchHeaderView()
    let tableView = UITableView()
    
    let sample = [UserSummaryTemp(userSummaryId: "a", name: "풍이", goal: "풍이는 기여워", imagePath: "ㅁㅁㅁ"),
                  UserSummaryTemp(userSummaryId: "a", name: "예삐", goal: "예삐는 뚱뚱해", imagePath: "ㅁㅁㅁ")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        configureDataSource()
        configureSnapshot()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.cellIdentifier)
        tableView.register(SearchHeaderView.self, forHeaderFooterViewReuseIdentifier: SearchHeaderView.cellIdentifier)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        headerView.dropDown.cellNib = UINib(nibName: "SortDropDownCell", bundle: nil)
        headerView.dropDown.dataSource = ScheduleSort.allCases.map { $0.description }
        headerView.dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? SortDropDownCell else { return }
            
        }
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.leading.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        
        let input = UserSearchViewModel.Input(
        )
        
        self.headerView.dropDown.selectionAction = { [unowned self] (_ : Int, item: String) in
            guard let sort = ScheduleSort.allCases.filter { $0.description == item }.first else {
                return
            }
            self.headerView.sortButton.setTitle(sort.description)
        }
        
        let output = viewModel?.transform(input: input)
    }

}

// MARK: TableView
extension UserSearchViewController {
    
    private func configureDataSource() {
        
        dataSource = UITableViewDiffableDataSource<Section, UserSummaryTemp>(tableView: tableView, cellProvider: { tableView, indexPath, user in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellIdentifier, for: indexPath) as? UserTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(imageUrl: user.imagePath, name: user.name, goal: user.goal)
            return cell
        })
    }
    
    func configureSnapshot(animatingDifferences: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserSummaryTemp>()
        snapshot.appendSections([.main])
        snapshot.appendItems(sample, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
}

extension UserSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}
