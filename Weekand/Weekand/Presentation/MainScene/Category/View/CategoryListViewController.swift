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
    
    let sample: [Category] = [
        Category(color: "red", name: "공부", openType: .allOpen),
        Category(color: "red", name: "자기계발", openType: .closed),
        Category(color: "red", name: "취미생활", openType: .followerOpen),
        Category(color: "red", name: "업무", openType: .closed),
        Category(color: "red", name: "to do", openType: .allOpen)
    ]
    
    private let disposeBag = DisposeBag()
    var viewModel: CategoryListViewModel?
    var dataSource: UITableViewDiffableDataSource<Section, Category>!
    
    var headerView = CategoryListHeaderView()
    let tableView = UITableView()
    
    var selectedSort: Sort = .nameCreateDESC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        configureDataSource()
        configureSnapshot()
        bindViewModel()
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
        headerView.dropDown.dataSource = Sort.allCases.map { $0.description }
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
        
        let input = CategoryListViewModel.Input(
            didTapAddCategoryButton: self.headerView.addCategoryButton.rx.tap.asObservable(),
            didCategoryCellSelected: self.tableView.rx.itemSelected.asObservable()
        )
        
        self.headerView.sortButton.rx.tap.subscribe(onNext: {
            self.headerView.dropDown.show()
        }).disposed(by: disposeBag)
        
        self.viewModel?.transform(input: input)
    }
}

// MARK: TableView
extension CategoryListViewController {
    
    private func configureDataSource() {
        
        dataSource = UITableViewDiffableDataSource<Section, Category>(tableView: tableView, cellProvider: { tableView, indexPath, list in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryListTableViewCell.cellIdentifier, for: indexPath) as? CategoryListTableViewCell else {
                return UITableViewCell()
            }
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
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

extension CategoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.sortButton.setTitle(selectedSort.description)
//        let dateCreatedAscAction = UIAction(title: "최신순") { _ in print("최신순") }
//        let dateCreateDesxAction = UIAction(title: "오래된순") { _ in print("오래된순") }
//        let nameCreatedAscAction = UIAction(title: "오름차순") { _ in print("오름차순") }
//        let nameCreateDescAction = UIAction(title: "내림차순") { _ in print("내림차순") }
//        let menu = UIMenu(title: "",
//                          image: nil,
//                          identifier: nil,
//                          options: .displayInline,
//                          children: [dateCreatedAscAction, dateCreateDesxAction, nameCreatedAscAction, nameCreateDescAction])
//        headerView.sortButton.menu = menu
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
