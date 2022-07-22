//
//  WeekRepeatViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/19.
//

import UIKit

class WeekRepeatViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    let radioTableViewlist = ["안함", "종료날짜 선택"]
    let weekList = ["일","월","화","수","목","금","토"]
    
    lazy var repeatRadioStackView = RepeatRadioStackView()
    var weekCollecitonView: UICollectionView! = nil
    
    lazy var buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.spacing = 10
    }

    let cancelButton = WDefaultButton(title: "취소", style: .tint, font: WFont.subHead1())
    let confirmButton = WDefaultButton(title: "확인", style: .filled, font: WFont.subHead1())
    
    var tableViewDataSource: UITableViewDiffableDataSource<Section, String>!
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, String>!
    var viewModel: WeekRepeatViewModel?
    
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
        let layout = UICollectionViewCompositionalLayout { (_: Int,
            _ : NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let screenWidth = UIScreen.main.bounds.width
            let itemSize = screenWidth * 0.096
            let edgeSpacing = screenWidth * 0.013
            let sectionInset = screenWidth * 0.021
            let collectionLayoutSize = NSCollectionLayoutSize(
                                widthDimension: .absolute(itemSize),
                                heightDimension: .absolute(itemSize))
            let item = NSCollectionLayoutItem(layoutSize: collectionLayoutSize)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(edgeSpacing), top: nil, trailing: .fixed(edgeSpacing), bottom: nil)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.1)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = .init(top: sectionInset, leading: 0, bottom: sectionInset, trailing: 0)

            return section
        }
        
        weekCollecitonView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        weekCollecitonView.delegate = self
        weekCollecitonView.isScrollEnabled = false
        weekCollecitonView.allowsMultipleSelection = true
        weekCollecitonView.register(WeekCollectionViewCell.self, forCellWithReuseIdentifier: WeekCollectionViewCell.cellIdentifier)
        
        repeatRadioStackView.tableView.delegate = self
        repeatRadioStackView.tableView.register(RepeatTableViewCell.self, forCellReuseIdentifier: RepeatTableViewCell.cellIdentifier)
    }
    
    private func configureUI() {
        self.view.addSubview(weekCollecitonView)
        self.view.addSubview(repeatRadioStackView)
        self.view.addSubview(cancelButton)
        self.view.addSubview(buttonStackView)
        
        weekCollecitonView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(45)
        }
        
        repeatRadioStackView.snp.makeConstraints { make in
            make.top.equalTo(weekCollecitonView.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview()
        }
        
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(confirmButton)
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(45)
        }

    }
    
    private func bindViewModel() {
        
    }
}

extension WeekRepeatViewController {
    private func configureDataSource() {
        
        tableViewDataSource = UITableViewDiffableDataSource<Section, String>(tableView: repeatRadioStackView.tableView, cellProvider: { tableView, indexPath, text in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RepeatTableViewCell.cellIdentifier, for: indexPath) as? RepeatTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(text: text)
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
            return cell
        })
        
        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: self.weekCollecitonView, cellProvider: { collectionView, indexPath, text in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCollectionViewCell.cellIdentifier, for: indexPath) as? WeekCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(text: text)
            return cell
        })
    }
    
    func configureSnapshot(animatingDifferences: Bool = false) {
        var listSnapshot = NSDiffableDataSourceSnapshot<Section, String>()
        listSnapshot.appendSections([.main])
        listSnapshot.appendItems(radioTableViewlist, toSection: .main)
        tableViewDataSource.apply(listSnapshot, animatingDifferences: animatingDifferences)
        
        var weekCollectionSnapshot = NSDiffableDataSourceSnapshot<Section, String>()
        weekCollectionSnapshot.appendSections([.main])
        weekCollectionSnapshot.appendItems(weekList, toSection: .main)
        collectionViewDataSource.apply(weekCollectionSnapshot, animatingDifferences: animatingDifferences)
    }
}

extension WeekRepeatViewController: UITableViewDelegate {
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

extension WeekRepeatViewController: UICollectionViewDelegate {
    
}
