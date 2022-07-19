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
    
    var list: [UserSummaryTemp] = []
    var UserCount: Int = 20
    var refreshListCount: Int = 15
    var page: Int = 0
    
    var selectedSort: UserSort = .dateCreatedDESC {
        didSet {
            self.setUserList(searchQuery: self.searchText, jobs: self.selectedJobs, interests: self.selectedInterests)
        }
    }
    var searchText: String {
        return self.headerView.searchBar.text ?? ""
    }
    var selectedJobs: [String] = [] {
        didSet {
            let count = selectedJobs.count == 0 ? nil : selectedJobs.count
            self.headerView.jobFilterButton.setTitle("직업 ", count)
            self.selectedJobsObservable.accept(selectedJobs)
        }
    }
    var selectedInterests: [String] = [] {
        didSet {
            let count = selectedInterests.count == 0 ? nil : selectedInterests.count
            self.headerView.interestsFilterButton.setTitle("관심사 ", count)
            self.selectedInterestsObservable.accept(selectedInterests)
        }
    }
    
    let selectedJobsObservable = BehaviorRelay<[String]>(value: [])
    let selectedInterestsObservable = BehaviorRelay<[String]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        configureDataSource()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureSnapshot(list: list)
    }
    
    private func setupView() {
        navigationItem.title = "유저 찾기"
        view.backgroundColor = .white
    
        setipTableView()
        setupDropDown()
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
            didTapJobFilterButton: headerView.jobFilterButton.rx.tap.asObservable(),
            didTapInterestsFilterButton: headerView.interestsFilterButton.rx.tap.asObservable(),
            didEditSearchBar: headerView.searchBar.rx.text.orEmpty.asObservable(),
            didTapSearchButton: headerView.searchBar.rx.searchButtonClicked.asObservable(),
            selectedJobs: selectedJobsObservable,
            selectedInterests: selectedInterestsObservable
        )
        
        self.headerView.dropDown.selectionAction = { [unowned self] (_ : Int, item: String) in
            guard let sort = UserSort.allCases.filter { $0.description == item }.first else {
                return
            }
            selectedSort = sort
            self.headerView.sortButton.setTitle(sort.description)
        }
        
        self.headerView.sortButton.rx.tap.subscribe(onNext: {
            self.headerView.dropDown.show()
        }).disposed(by: disposeBag)
        
        let output = viewModel?.transform(input: input)
        
        output?.searchWithInformation
            .filter { $0 != [] || $1 != [] }
            .subscribe(onNext: { (jobs, interests) in
                self.setUserList(searchQuery: self.searchText, jobs: jobs, interests: interests)
        })
        .disposed(by: disposeBag)
        
        output?.searchWithQueryInformation
            .subscribe(onNext: { (jobs, interests) in
                self.setUserList(searchQuery: self.searchText, jobs: jobs, interests: interests)
            })
            .disposed(by: disposeBag)
        
        self.viewModel?.userList
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] userList in
                userList.forEach { self?.list.append($0) }
                self?.configureSnapshot(list: self?.list ?? [])
        })
        .disposed(by: self.disposeBag)
    }
    
    private func setipTableView() {
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.cellIdentifier)
        tableView.register(SearchHeaderView.self, forHeaderFooterViewReuseIdentifier: SearchHeaderView.cellIdentifier)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    private func setupDropDown() {
        headerView.dropDown.cellNib = UINib(nibName: "SortDropDownCell", bundle: nil)
        headerView.dropDown.dataSource = UserSort.allCases.map { $0.description }
        headerView.dropDown.customCellConfiguration = { (_: Index, _: String, cell: DropDownCell) -> Void in
            guard let _ = cell as? SortDropDownCell else { return }
        }
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
    
    func configureSnapshot(animatingDifferences: Bool = false, list: [UserSummaryTemp]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserSummaryTemp>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
}

extension UserSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.item)
        if indexPath.item == refreshListCount * (page + 1) - 1 {
            page += 1
            self.appendUserList(searchQuery: self.searchText, jobs: self.selectedJobs, interests: selectedInterests)
        }
    }
}

extension UserSearchViewController {
    func setUserList(searchQuery: String, jobs: [String], interests: [String]) {
        self.page = 0
        self.list = []
        self.viewModel?.searchUsers(
                            searchQuery: searchQuery,
                            jobs: jobs,
                            interests: interests,
                            sort: self.selectedSort,
                            page: self.page,
                            size: self.UserCount)
        self.tableView.scrollToTop()
    }
    
    func appendUserList(searchQuery: String, jobs: [String], interests: [String]) {
        self.viewModel?.loadMoreUserList(searchQuery: searchQuery, jobs: jobs, interests: interests, sort: self.selectedSort, page: page, size: UserCount)
    }
}
