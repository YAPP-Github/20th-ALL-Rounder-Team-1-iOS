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

class CategoryListViewController: UIViewController {
    
    enum Section {
      case main
    }
//
//    let sample: [Category] = [
//        Category(id: "1", color: "red", name: "공부", openType: .allOpen),
//        Category(id: "1", color: "red", name: "자기계발", openType: .closed),
//        Category(id: "1", color: "red", name: "취미생활", openType: .followerOpen),
//        Category(id: "1", color: "red", name: "업무", openType: .closed),
//        Category(id: "1", color: "red", name: "to do", openType: .allOpen)
//    ]
    
    private let disposeBag = DisposeBag()
    var viewModel: CategoryListViewModel?
    var dataSource: UITableViewDiffableDataSource<Section, Category>!
    
    var headerView = CategoryListHeaderView()
    let tableView = UITableView()
    
    var list: [Category] = []
    var categoryCount: Int = 5
    var page: Int = 0
    var selectedSort: ScheduleSort = .nameCreateDESC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        configureDataSource()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setCategoryList()
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
        let dropDownDidSelectEvent = BehaviorRelay(value: ScheduleSort.nameCreateDESC)
        
        let input = CategoryListViewModel.Input(
            didTapAddCategoryButton: self.headerView.addCategoryButton.rx.tap.asObservable(),
            didCategoryCellSelected: self.tableView.rx.itemSelected.asObservable(),
            dropDownDidSelectEvent: dropDownDidSelectEvent
        )
        
        self.headerView.dropDown.selectionAction = { [unowned self] (_ : Int, item: String) in
            guard let selectedSort = ScheduleSort.allCases.filter { $0.description == item }.first else {
                return
            }
            
            dropDownDidSelectEvent.accept(selectedSort)
            self.headerView.sortButton.setTitle(selectedSort.description)
        }
        
        self.headerView.sortButton.rx.tap.subscribe(onNext: {
            self.headerView.dropDown.show()
        }).disposed(by: disposeBag)
        
        let output = viewModel?.transform(input: input)
    }
}

// MARK: TableView
extension CategoryListViewController {
    
    private func configureDataSource() {
        
        dataSource = UITableViewDiffableDataSource<Section, Category>(tableView: tableView, cellProvider: { tableView, indexPath, category in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryListTableViewCell.cellIdentifier, for: indexPath) as? CategoryListTableViewCell else {
                return UITableViewCell()
            }
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            cell.configure(color: UIColor(hex: category.color)!, openType: category.openType, name: category.name)
            return cell
        })
    }
    
    func configureSnapshot(animatingDifferences: Bool = true, list: [Category]) {

        var snapshot = NSDiffableDataSourceSnapshot<Section, Category>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
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
}

extension CategoryListViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let update = UIContextualAction(style: .normal, title: "수정") { _, _, _ in
            print("수정 클릭 됨")
        }
        update.backgroundColor = .mainColor
        
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { _, _, _ in
            self.showActionSheet(titles: "삭제", message: "카테고리를 삭제하시겠어요?") { _ in
                print("삭제~~")
            }
        }
        delete.backgroundColor = .wred
        
        return UISwipeActionsConfiguration(actions: [delete, update])
    }
}

extension CategoryListViewController {
    func setCategoryList() {
        self.viewModel?.saerchCategories(sort: selectedSort, page: page, size: categoryCount)
        self.viewModel?.categoryList
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] categoryList in
                self?.configureSnapshot(list: categoryList)
                self?.list = categoryList
        })
        .disposed(by: disposeBag)
        
    }
}


import SwiftUI
#if canImport(SwiftUI) && DEBUG

struct CategoryListViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            CategoryListViewController().showPreview(.iPhone11Pro)
        }
    }
}
#endif
