//
//  CategoryListViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/07.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import DropDown

enum CategorySection {
  case main
}

class CategoryListViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel: CategoryListViewModel?
    var dataSource: CategoryDataSource!
    
    var headerView = CategoryListHeaderView()
    let tableView = UITableView()
    
    var list: [Category] = []
    var categoryCount: Int = 20
    var refreshListCount: Int = 15
    var page: Int = 0
    var selectedSort: ScheduleSort = .dateCreatedDESC {
        didSet {
            self.setCategoryList(sort: selectedSort)
        }
    }
    
    let categoryCellDidSelected = PublishRelay<Category>()
    let categoryCellDidSwipeEvent = PublishRelay<Category>()
    
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
        setCategoryList(sort: selectedSort)
    }

    
    private func setupView() {
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.register(CategoryListTableViewCell.self, forCellReuseIdentifier: CategoryListTableViewCell.cellIdentifier)
        tableView.register(CategoryListHeaderView.self, forHeaderFooterViewReuseIdentifier: CategoryListHeaderView.cellIdentifier)
        
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
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.leading.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        
        let input = CategoryListViewModel.Input(
            didTapAddCategoryButton: self.headerView.addCategoryButton.rx.tap.asObservable(),
            categoryCellDidSelected: categoryCellDidSelected,
            categoryCellDidSwipeEvent: categoryCellDidSwipeEvent
        )
        
        self.headerView.dropDown.selectionAction = { [unowned self] (_ : Int, item: String) in
            guard let sort = ScheduleSort.allCases.filter({ $0.description == item }).first else {
                return
            }
            selectedSort = sort
            self.headerView.sortButton.setTitle(sort.description)
        }
        
        self.viewModel?.categoryList
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] categoryList in
                categoryList.forEach { self?.list.append($0) }
                self?.configureSnapshot(list: self?.list ?? [])
        })
        .disposed(by: self.disposeBag)
        
        self.headerView.sortButton.rx.tap.subscribe(onNext: {
            self.headerView.dropDown.show()
        }).disposed(by: disposeBag)
        
        viewModel?.transform(input: input)
    }
}

// MARK: TableView
extension CategoryListViewController {
    
    private func configureDataSource() {
        
        dataSource = CategoryDataSource(tableView: tableView, cellProvider: { tableView, indexPath, category in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryListTableViewCell.cellIdentifier, for: indexPath) as? CategoryListTableViewCell else {
                return UITableViewCell()
            }
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            cell.configure(color: UIColor(hex: category.color)!, openType: category.openType, name: category.name)
            return cell
        })
    }
    
    func configureSnapshot(animatingDifferences: Bool = false, list: [Category]) {
        var snapshot = NSDiffableDataSourceSnapshot<CategorySection, Category>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func deleteItem(_ indexPath: IndexPath) {
        var snapshot = self.dataSource.snapshot()
        snapshot.deleteItems([self.list[indexPath.item]])
        self.list.remove(at: indexPath.item)
        self.dataSource.apply(snapshot)
    }
    
}

extension CategoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.sortButton.setTitle(selectedSort.description)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == refreshListCount * (page + 1) {
            page += 1
            self.appendCategoryList()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryCellDidSelected.accept(list[indexPath.item])
    }
}

extension CategoryListViewController {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let update = UIContextualAction(style: .normal, title: "수정") { _, _, completionHandler in
            self.categoryCellDidSwipeEvent.accept(self.list[indexPath.item])
            completionHandler(true)
        }
        update.backgroundColor = .mainColor
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { _, _, completionHandler in
            self.showActionSheet(titles: "삭제", message: "카테고리를 삭제하시겠어요?") { _ in
                self.viewModel?.deleteCategory(id: self.list[indexPath.item].serverID) {
                    self.deleteItem(indexPath)
                    completionHandler(true)
                }
            }
        }
        delete.backgroundColor = .wred
        
        return UISwipeActionsConfiguration(actions: [delete, update])
    }
}

extension CategoryListViewController {
    func setCategoryList(sort: ScheduleSort = .dateCreatedDESC) {
        self.page = 0
        self.list = []
        self.viewModel?.searchCategories(sort: sort, page: page, size: categoryCount)
        self.tableView.scrollToTop()
    }
    
    func appendCategoryList() {
        self.viewModel?.searchCategories(sort: selectedSort, page: page, size: categoryCount)
    }
}
