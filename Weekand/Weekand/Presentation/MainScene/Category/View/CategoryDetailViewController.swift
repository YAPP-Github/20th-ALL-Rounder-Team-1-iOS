//
//  CategoryDetailViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/11.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import DropDown

enum ScheduleSection {
  case main
}

class CategoryDetailViewController: UIViewController {

    private let disposeBag = DisposeBag()
    var viewModel: CategoryDetailViewModel?
    var dataSource: ScheduleSummaryDataSource!
    
    let tableView = UITableView()
    let headerView = CategoryDetailHeaderView()
    let toolBar = CategoryDetailToolBar()
    let backgroundEmtpyView = WEmptyView(type: .schedule)
    
    var searchText: String = ""
    var selectedSort: ScheduleSort = .dateCreatedDESC {
        didSet {
            self.setScheduleList()
        }
    }
    var selectedCategory: Category? {
        didSet {
            self.navigationItem.title = selectedCategory?.name
        }
    }
    
    var list: [ScheduleSummary] = [] {
        didSet {
            self.toolBar.setScheduleCount(self.list.count)
        }
    }
    var scheduleCount: Int = 20
    var refreshListCount: Int = 15
    var page: Int = 0
    
    let scheduleCellDidSelected = PublishRelay<ScheduleSummary>()
    let scheduleCellDidSwipeEvent = PublishRelay<ScheduleSummary>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        bindViewModel()
        configureDataSource()
        setupEndEditing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setScheduleList()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.register(CategoryDetailTableViewCell.self, forCellReuseIdentifier: CategoryDetailTableViewCell.cellIdentifier)
        tableView.register(CategoryDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: CategoryDetailHeaderView.cellIdentifier)
        tableView.backgroundView = backgroundEmtpyView
        tableView.backgroundView?.isHidden = true
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        headerView.dropDown.cellNib = UINib(nibName: "SortDropDownCell", bundle: nil)
        headerView.dropDown.dataSource = ScheduleSort.allCases.map { $0.description }
        headerView.dropDown.customCellConfiguration = { (_: Index, _: String, cell: DropDownCell) -> Void in
            guard cell is SortDropDownCell else { return }
        }
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        view.addSubview(toolBar)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-self.toolBar.viewHeight)
            make.trailing.leading.equalToSuperview()
        }
        
        toolBar.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(self.toolBar.viewHeight)
        }
    }
    
    private func bindViewModel() {
        let input = CategoryDetailViewModel.Input(
            didEditSearchBar: self.headerView.searchBar.rx.text.orEmpty.asObservable(),
            didTapUpdateCategoryButton: self.toolBar.updateCategoryButton.rx.tap.asObservable(),
            scheduleCellDidSelected: scheduleCellDidSelected,
            scheduleCellDidSwipeEvent: scheduleCellDidSwipeEvent,
            selectedCategory: selectedCategory
        )
        
        self.headerView.dropDown.selectionAction = { [unowned self] (_ : Int, item: String) in
            guard let sort = ScheduleSort.allCases.filter({ $0.description == item }).first else {
                return
            }
            selectedSort = sort
            self.headerView.sortButton.setTitle(selectedSort.description)
        }
        
        self.headerView.sortButton.rx.tap.subscribe(onNext: {
            self.headerView.dropDown.show()
        }).disposed(by: disposeBag)
        
        let output = viewModel?.transform(input: input)
        
        output?.searchWithQueryInformation
            .subscribe(onNext: { (searchText) in
                self.searchText = searchText
                self.setScheduleList()
            })
            .disposed(by: disposeBag)
        
        self.viewModel?.scheduleList
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] scheduleList in
                scheduleList.forEach { self?.list.append($0) }
                self?.configureSnapshot(list: self?.list ?? [])
        })
        .disposed(by: self.disposeBag)
    }

}

// MARK: TableView
extension CategoryDetailViewController {
    
    private func configureDataSource() {
        
        dataSource = ScheduleSummaryDataSource(tableView: tableView, cellProvider: { tableView, indexPath, list in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryDetailTableViewCell.cellIdentifier, for: indexPath) as? CategoryDetailTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(color: UIColor(hex: list.color) ?? .mainColor,
                           title: list.name,
                           date: WDateFormatter.dateFormatter.string(from: list.dateStart),
                           time: WDateFormatter.combineTimeDate(startTime: list.dateStart, endTime: list.dateEnd),
                           repeatText: WRepeatTextManager.combineTimeDate(repeatType: list.repeatType,
                                                                          repeatSelectedValue: list.repeatSelectedValue,
                                                                          repeatEndDate: nil))
            return cell
        })
    }
    
    private func configureSnapshot(animatingDifferences: Bool = false, list: [ScheduleSummary]) {

        var snapshot = NSDiffableDataSourceSnapshot<ScheduleSection, ScheduleSummary>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
        if self.list.isEmpty {
            tableView.backgroundView?.isHidden = false
        } else {
            tableView.backgroundView?.isHidden = true
        }
    }
    
    func deleteItem(_ indexPath: IndexPath) {
        var snapshot = self.dataSource.snapshot()
        snapshot.deleteItems([self.list[indexPath.item]])
        self.list.remove(at: indexPath.item)
        self.dataSource.apply(snapshot)
    }
    
}

extension CategoryDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.sortButton.setTitle(selectedSort.description)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == refreshListCount * (page + 1) - 1 {
            page += 1
            self.appendUserList()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scheduleCellDidSelected.accept(list[indexPath.item])
    }
}

extension CategoryDetailViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let update = UIContextualAction(style: .normal, title: "수정") { _, _, completionHandler in
            self.scheduleCellDidSwipeEvent.accept(self.list[indexPath.item])
            completionHandler(true)
        }
        update.backgroundColor = .mainColor
        
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { _, _, completionHandler in
            self.showActionSheet(titles: "삭제", message: "이 기간의 모든 일정을 삭제하시겠어요?") { _ in
                self.viewModel?.deleteSchedule(schedule: self.list[indexPath.item], completion: {
                    self.deleteItem(indexPath)
                    completionHandler(true)
                })
            }

        }
        delete.backgroundColor = .wred
        
        return UISwipeActionsConfiguration(actions: [delete, update])
    }
}

extension CategoryDetailViewController {
    func setScheduleList() {
        self.page = 0
        self.list = []
        self.viewModel?.searchSchedules(sort: self.selectedSort, page: self.page, size: self.scheduleCount, searchQuery: self.searchText, categoryId: self.selectedCategory?.serverID ?? "")
        self.tableView.scrollToTop()
    }
    
    func appendUserList() {
        self.viewModel?.loadMoreScheduelList(sort: self.selectedSort, page: self.page, size: self.scheduleCount, searchQuery: self.searchText, categoryId: self.selectedCategory?.serverID ?? "")
    }
}

// keyboard

extension CategoryDetailViewController {
    private func setupEndEditing() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(tapAction))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc func tapAction(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
