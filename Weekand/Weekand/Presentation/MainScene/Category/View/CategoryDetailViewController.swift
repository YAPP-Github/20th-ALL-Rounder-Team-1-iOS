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

class CategoryDetailViewController: UIViewController {

    enum Section {
      case main
    }
    
    let sample: [ScehduleMain] = [
        ScehduleMain(scheduleId: "0", color: "red", name: "일정 제목1", dateStart: Date(), dataEnd: Date(), stickerCount: 134, stickerNameList: []),
        ScehduleMain(scheduleId: "0", color: "red", name: "일정 제목2", dateStart: Date(), dataEnd: Date(), stickerCount: 313, stickerNameList: []),
        ScehduleMain(scheduleId: "0", color: "red", name: "일정 제목3", dateStart: Date(), dataEnd: Date(), stickerCount: 54, stickerNameList: []),
        ScehduleMain(scheduleId: "0", color: "red", name: "일정 제목4", dateStart: Date(), dataEnd: Date(), stickerCount: 431, stickerNameList: []),
        ScehduleMain(scheduleId: "0", color: "red", name: "일정 제목5", dateStart: Date(), dataEnd: Date(), stickerCount: 64, stickerNameList: []),
        ScehduleMain(scheduleId: "0", color: "red", name: "일정 제목6", dateStart: Date(), dataEnd: Date(), stickerCount: 3, stickerNameList: []),
        ScehduleMain(scheduleId: "0", color: "red", name: "일정 제목7", dateStart: Date(), dataEnd: Date(), stickerCount: 13, stickerNameList: [])
    ]
    
    private let disposeBag = DisposeBag()
    var viewModel: CategoryDetailViewModel?
    var dataSource: UITableViewDiffableDataSource<Section, ScehduleMain>!
    
    let tableView = UITableView()
    var headerView = CategoryDetailHeaderView()
    
    var selectedSort: ScheduleSort = .nameCreateDESC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        bindViewModel()
        configureDataSource()
        configureSnapshot()
        setupEndEditing()
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
        tableView.register(CategoryDetailFooterView.self, forHeaderFooterViewReuseIdentifier: CategoryDetailFooterView.cellIdentifier)
        
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
        
        let input = CategoryDetailViewModel.Input(
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
    }

}

// MARK: TableView
extension CategoryDetailViewController {
    
    private func configureDataSource() {
        
        dataSource = UITableViewDiffableDataSource<Section, ScehduleMain>(tableView: tableView, cellProvider: { tableView, indexPath, list in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryDetailTableViewCell.cellIdentifier, for: indexPath) as? CategoryDetailTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(color: .wred, title: list.name, startDate: "2022.05.21 06:00", endDate: "2022.05.28 08:00", repeatText: "매주 화요일 반복")
            return cell
        })
    }
    
    private func configureSnapshot(animatingDifferences: Bool = true) {

        var snapshot = NSDiffableDataSourceSnapshot<Section, ScehduleMain>()
        snapshot.appendSections([.main])
        snapshot.appendItems(sample, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
}

extension CategoryDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.sortButton.setTitle(selectedSort.description)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return CategoryDetailFooterView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 58
    }
}

extension CategoryDetailViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let update = UIContextualAction(style: .normal, title: "수정") { _, _, _ in
            print("수정 클릭 됨")
        }
        update.backgroundColor = .mainColor
        
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { _, _, _ in
            self.showActionSheet(titles: "삭제", message: "이 기간의 모든 일정을 삭제하시겠어요?") { _ in
                print("삭제~~")
            }

        }
        delete.backgroundColor = .wred
        
        return UISwipeActionsConfiguration(actions: [delete, update])
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
