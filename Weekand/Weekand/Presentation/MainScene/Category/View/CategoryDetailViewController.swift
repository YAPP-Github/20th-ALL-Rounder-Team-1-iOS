//
//  CategoryDetailViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/11.
//

import UIKit

class CategoryDetailViewController: UIViewController {

    enum Section {
      case main
    }
    
    let sample: [ScheduleList] = [
        ScheduleList(scheduleId: 0, color: "red", name: "일정 제목1", dateStart: Date(), dataEnd: Date(), stickerCount: 134, stickerNameList: []),
        ScheduleList(scheduleId: 0, color: "red", name: "일정 제목2", dateStart: Date(), dataEnd: Date(), stickerCount: 313, stickerNameList: []),
        ScheduleList(scheduleId: 0, color: "red", name: "일정 제목3", dateStart: Date(), dataEnd: Date(), stickerCount: 54, stickerNameList: []),
        ScheduleList(scheduleId: 0, color: "red", name: "일정 제목4", dateStart: Date(), dataEnd: Date(), stickerCount: 431, stickerNameList: []),
        ScheduleList(scheduleId: 0, color: "red", name: "일정 제목5", dateStart: Date(), dataEnd: Date(), stickerCount: 64, stickerNameList: []),
        ScheduleList(scheduleId: 0, color: "red", name: "일정 제목6", dateStart: Date(), dataEnd: Date(), stickerCount: 3, stickerNameList: []),
        ScheduleList(scheduleId: 0, color: "red", name: "일정 제목7", dateStart: Date(), dataEnd: Date(), stickerCount: 13, stickerNameList: [])
    ]
    
    var dataSource: UITableViewDiffableDataSource<Section, ScheduleList>!
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        bindViewModel()
        configureDataSource()
        configureSnapshot()
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(CategoryDetailTableViewCell.self, forCellReuseIdentifier: CategoryDetailTableViewCell.cellIdentifier)
        tableView.register(CategoryDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: CategoryDetailHeaderView.cellIdentifier)
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
extension CategoryDetailViewController {
    
    private func configureDataSource() {
        
        dataSource = UITableViewDiffableDataSource<Section, ScheduleList>(tableView: tableView, cellProvider: { tableView, indexPath, list in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryDetailTableViewCell.cellIdentifier, for: indexPath) as? CategoryDetailTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(color: .wred, title: list.name, startDate: "2022.05.21 06:00", endDate: "2022.05.28 08:00", repeatText: "매주 화요일 반복")
            return cell
        })
    }
    
    private func configureSnapshot(animatingDifferences: Bool = true) {

        var snapshot = NSDiffableDataSourceSnapshot<Section, ScheduleList>()
        snapshot.appendSections([.main])
        snapshot.appendItems(sample, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
}

extension CategoryDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return CategoryDetailHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
}

extension CategoryDetailViewController {
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

struct CategoryDetailViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            CategoryDetailViewController().showPreview(.iPhone11Pro)
        }
    }
}
#endif
