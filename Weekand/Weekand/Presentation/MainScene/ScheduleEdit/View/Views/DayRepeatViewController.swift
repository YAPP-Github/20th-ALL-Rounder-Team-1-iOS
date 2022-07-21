//
//  DayRepeatViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/19.
//

import UIKit

class DayRepeatViewController: UIViewController {
    
    enum Section {
      case main
    }
    
    let list = ["안함", "종료날짜 선택"]
    
    lazy var repeatRadioStackView = RepeatRadioStackView()
    
    var dataSource: UITableViewDiffableDataSource<Section, String>!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
        bindViewModel()
        configureDataSource()
        configureSnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        repeatRadioStackView.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
    }
    
    
    private func setUpView() {
        repeatRadioStackView.tableView.delegate = self
        repeatRadioStackView.tableView.register(RepeatTableViewCell.self, forCellReuseIdentifier: RepeatTableViewCell.cellIdentifier)
    }
    
    private func configureUI() {
        self.view.addSubview(repeatRadioStackView)
        
        repeatRadioStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.trailing.leading.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        
    }
}

extension DayRepeatViewController {
    private func configureDataSource() {
        
        dataSource = UITableViewDiffableDataSource<Section, String>(tableView: repeatRadioStackView.tableView, cellProvider: { tableView, indexPath, text in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RepeatTableViewCell.cellIdentifier, for: indexPath) as? RepeatTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(text: text)
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
            return cell
        })
    }
    
    func configureSnapshot(animatingDifferences: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension DayRepeatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dateSelectIndex = 1
        if indexPath.row == dateSelectIndex {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                self.repeatRadioStackView.calendarContainerView.alpha = 1
                self.repeatRadioStackView.calendarContainerView.isHidden = false
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let dateSelectIndex = 1
        if indexPath.row == dateSelectIndex {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                self.repeatRadioStackView.calendarContainerView.alpha = 0
                self.repeatRadioStackView.calendarContainerView.isHidden = true
            }, completion: nil)
        }
    }
}
