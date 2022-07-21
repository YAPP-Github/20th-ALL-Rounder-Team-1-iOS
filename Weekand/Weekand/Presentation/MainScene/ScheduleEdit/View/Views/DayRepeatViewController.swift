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
    
    lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    lazy var namelabel = WTextLabel().then {
        $0.textColor = UIColor.gray900
        $0.font = WFont.subHead2()
        $0.text = "반복종료"
    }
    
    let tableView = UITableView()
    
    lazy var dividerLine = UIView().then {
        $0.backgroundColor = .gray200
    }
    
    lazy var calendarContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.isHidden = true
    }
    
    let calendarView = WCalendarView()
    
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
        
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
    }
    
    
    private func setUpView() {
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        
        tableView.register(RepeatTableViewCell.self, forCellReuseIdentifier: RepeatTableViewCell.cellIdentifier)
    }
    
    private func configureUI() {
        self.view.addSubview(stackView)
        
        stackView.addArrangedSubview(namelabel)
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(dividerLine)
        stackView.addArrangedSubview(calendarContainerView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.trailing.leading.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        dividerLine.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        calendarContainerView.addSubview(calendarView)
        
        calendarContainerView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(350)
        }
        
        calendarView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        
    }
}

extension DayRepeatViewController {
    private func configureDataSource() {
        
        dataSource = UITableViewDiffableDataSource<Section, String>(tableView: tableView, cellProvider: { tableView, indexPath, text in
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
                self.calendarContainerView.alpha = 1
                self.calendarContainerView.isHidden = false
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let dateSelectIndex = 1
        if indexPath.row == dateSelectIndex {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                self.calendarContainerView.alpha = 0
                self.calendarContainerView.isHidden = true
            }, completion: nil)
        }
    }
}
