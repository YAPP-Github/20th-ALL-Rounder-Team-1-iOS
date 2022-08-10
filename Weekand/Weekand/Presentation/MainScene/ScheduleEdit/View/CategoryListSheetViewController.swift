//
//  CategoryListSheetViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/21.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryListSheetViewController: BottomSheetViewController {
    
    // CollectionView
    
    enum Section {
      case main
    }
    
    var dataSource: UITableViewDiffableDataSource<Section, Category>!
    
    // ViewMoel
    
    private let disposeBag = DisposeBag()
    var viewModel: CategoryListSheetViewModel?
    
    // SheetHeight
    
    override var bottomSheetHeight: CGFloat {
        get {
            return 350
        }
    }
    
    // Views
    
    lazy var sheetTitle = WTextLabel().then {
        $0.font = WFont.body1()
        $0.textColor = .gray900
        $0.text = "카테고리"
    }
    
    let tableView = UITableView()
    
    // stored property
    
    var selectedCategory = PublishRelay<Category>()
    var categoryCount: Int = 10
    var refreshListCount: Int = 8
    var page: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        bindViewModel()
        configureDataSource()
        configureSnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setCategoryList()
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CategorySheetTableViewCell.self, forCellReuseIdentifier: CategorySheetTableViewCell.cellIdentifier)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    private func configureUI() {
        bottomSheetView.addSubview(sheetTitle)
        sheetTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.leading.equalToSuperview().offset(20)
        }
        
        bottomSheetView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(sheetTitle.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    private func bindViewModel() {
        
        let input = CategoryListSheetViewModel.Input(
            selectedCategory: selectedCategory
        )
        
        viewModel?.transform(input: input)
        
        self.viewModel?.categoryList
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] categoryList in
                self?.appendItems(list: categoryList)
        })
        .disposed(by: self.disposeBag)
    }

}

// MARK: - TableView

extension CategoryListSheetViewController {
    
    private func configureDataSource() {
        
        dataSource = UITableViewDiffableDataSource<Section, Category>(tableView: self.tableView, cellProvider: { tableView, indexPath, category in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategorySheetTableViewCell.cellIdentifier, for: indexPath) as? CategorySheetTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(color: UIColor(hex: category.color)!, name: category.name)
            return cell
        })
    }
    
    func configureSnapshot(animatingDifferences: Bool = false, list: [Category] = []) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Category>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func appendItems(list: [Category]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(list, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension CategoryListSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let category = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        self.selectedCategory.accept(category)
    }
}

// MARK: - Network

extension CategoryListSheetViewController {
    func setCategoryList(sort: ScheduleSort = .dateCreatedDESC) {
        self.page = 0
        self.viewModel?.searchCategories(sort: sort, page: page, size: categoryCount)
        self.tableView.scrollToTop()
        self.configureSnapshot()
    }
    
    func appendCategoryList() {
        self.viewModel?.searchCategories(sort: .dateCreatedDESC, page: page, size: categoryCount)
    }
}
