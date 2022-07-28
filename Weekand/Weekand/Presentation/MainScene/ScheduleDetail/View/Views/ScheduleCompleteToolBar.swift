//
//  ScheduleCompleteToolBar.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/29.
//

import UIKit

class ScheduleCompleteToolBar: UIToolbar {
    
    enum Section {
        case main
    }
    
    let viewHeight = 100
    
    let completelist: [CompleteStatus] = [.incomplete, .complete]
    
    var completeCollecitonView: UICollectionView! = nil
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, CompleteStatus>!
    
    lazy var scheduleCountLabel = UILabel().then {
        $0.textColor = .mainColor
        $0.font = WFont.body2()
    }
    
    let incompletedButton = WDefaultButton(title: "미완료", style: .tint, font: WFont.subHead1())
    let completedButton = WDefaultButton(title: "완료", style: .tint, font: WFont.subHead1())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        configureUI()
        configureDataSource()
        configureSnapshot()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        self.barTintColor = .white
        self.clipsToBounds = true
        self.layer.borderWidth = 0
        
        let layout = UICollectionViewCompositionalLayout { (_: Int,
            _ : NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            
            let collectionLayoutSize = NSCollectionLayoutSize(
                                widthDimension: .absolute(150),
                                heightDimension: .absolute(50))
            let item = NSCollectionLayoutItem(layoutSize: collectionLayoutSize)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(5), top: nil, trailing: .fixed(5), bottom: nil)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.1)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

            return section
        }
        
        completeCollecitonView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        completeCollecitonView.isScrollEnabled = false
        completeCollecitonView.allowsMultipleSelection = false
        completeCollecitonView.register(CompleteCollectionViewCell.self, forCellWithReuseIdentifier: CompleteCollectionViewCell.cellIdentifier)
    }
    
    private func configureDataSource() {
        
        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, CompleteStatus>(collectionView: self.completeCollecitonView, cellProvider: { collectionView, indexPath, status in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompleteCollectionViewCell.cellIdentifier, for: indexPath) as? CompleteCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(completeStatus: status)
            return cell
        })
    }
    
    func configureSnapshot(animatingDifferences: Bool = false) {
        var weekCollectionSnapshot = NSDiffableDataSourceSnapshot<Section, CompleteStatus>()
        weekCollectionSnapshot.appendSections([.main])
        weekCollectionSnapshot.appendItems(completelist, toSection: .main)
        collectionViewDataSource.apply(weekCollectionSnapshot, animatingDifferences: animatingDifferences)
    }
    
    func configureUI() {
        self.addSubview(completeCollecitonView)
        
        completeCollecitonView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.leading.equalToSuperview().inset(24)
            make.height.equalTo(60)
        }
    }
}
