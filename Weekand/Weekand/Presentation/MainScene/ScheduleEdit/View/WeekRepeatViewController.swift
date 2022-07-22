//
//  WeekRepeatViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/19.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class WeekRepeatViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    let radioTableViewlist = ["안함", "종료날짜 선택"]
    let weekList = ScheduleWeek.allCases.map { $0.description }
    
    lazy var repeatRadioStackView = RepeatRadioStackView()
    var weekCollecitonView: UICollectionView! = nil
    
    lazy var buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.spacing = 10
    }

    let cancelButton = WDefaultButton(title: "취소", style: .tint, font: WFont.subHead1())
    let confirmButton = WDefaultButton(title: "확인", style: .filled, font: WFont.subHead1())
    
    private let disposeBag = DisposeBag()
    var tableViewDataSource: UITableViewDiffableDataSource<Section, String>!
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, String>!
    var viewModel: WeekRepeatViewModel?
    
    let isSelectedRepeatEndDate = BehaviorRelay(value: false)
    let selectedRepeatWeek = BehaviorRelay<[ScheduleWeek]>(value: [])
    let selectedRepeatEndDate = BehaviorRelay<Date>(value: Date())
    
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
        
        let calendar = NSCalendar.current
        let component = calendar.component(.weekday, from: Date())
        repeatRadioStackView.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        weekCollecitonView.selectItem(at: IndexPath(item: component - 1, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        let weeks = weekCollecitonView
                    .indexPathsForSelectedItems?
                    .map { ScheduleWeek.allCases[$0.item] }
        self.selectedRepeatWeek.accept(weeks ?? [])
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
        let input = WeekRepeatViewModel.Input(
            isSelectedRepeatEndDate: isSelectedRepeatEndDate,
            selectedRepeatWeek: selectedRepeatWeek,
            repeatEndDateDidSelectEvent: selectedRepeatEndDate,
            cancelButtonDidTapEvent: self.cancelButton.rx.tap.asObservable(),
            confirmButtonDidTapEvent: self.confirmButton.rx.tap.asObservable()
        )
        
        repeatRadioStackView.calendarView.calendar.rx.didSelect
            .bind(to: selectedRepeatEndDate)
            .disposed(by: disposeBag)
        
        let _ = viewModel?.transform(input: input)
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
            self.isSelectedRepeatEndDate.accept(true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let dateSelectIndex = 1
        if indexPath.row == dateSelectIndex {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                self.repeatRadioStackView.calendarContainerView.alpha = 0
                self.repeatRadioStackView.calendarContainerView.isHidden = true
            }, completion: nil)
            self.isSelectedRepeatEndDate.accept(false)
        }
    }
}

extension WeekRepeatViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if let weeks = collectionView.indexPathsForSelectedItems,
           weeks.count <= 1 {
            return false
        } else {
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weeks = collectionView
                    .indexPathsForSelectedItems?
                    .map { ScheduleWeek.allCases[$0.item] }
        self.selectedRepeatWeek.accept(weeks ?? [])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let weeks = collectionView
                    .indexPathsForSelectedItems?
                    .map { ScheduleWeek.allCases[$0.item] }
        self.selectedRepeatWeek.accept(weeks ?? [])
    }
}
