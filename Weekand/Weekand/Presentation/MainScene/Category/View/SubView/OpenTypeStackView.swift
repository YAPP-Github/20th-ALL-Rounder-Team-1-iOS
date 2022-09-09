//
//  OpenTypeStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/11.
//

import UIKit

class OpenTypeStackView: UIStackView {
    
    enum Section {
        case main
    }

    lazy var namelabel = WTextLabel().then {
        $0.textColor = UIColor.gray800
        $0.text = "공개"
    }
    
    var openTypeCollecitonView: UICollectionView! = nil
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, CategoryOpenType>!
    
    let openTypelist = CategoryOpenType.openTypeList
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
        configureDataSource()
        configureSnapshot()
        setupView()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        setupCollectionView()
        configureDataSource()
        configureSnapshot()
        setupView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { (_: Int, _ : NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            
            let collectionLayoutSize = NSCollectionLayoutSize(widthDimension: .estimated(90),
                                                              heightDimension: .absolute(40))
            let item = NSCollectionLayoutItem(layoutSize: collectionLayoutSize)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(10), bottom: nil)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.1)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

            return section
        }
        
        openTypeCollecitonView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        openTypeCollecitonView.isScrollEnabled = false
        openTypeCollecitonView.allowsMultipleSelection = false
        openTypeCollecitonView.backgroundColor = .clear
        openTypeCollecitonView.register(OpenTypeCollectionViewCell.self, forCellWithReuseIdentifier: OpenTypeCollectionViewCell.cellIdentifier)
    }
    
    private func configureDataSource() {
        
        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, CategoryOpenType>(collectionView: self.openTypeCollecitonView, cellProvider: { collectionView, indexPath, openType in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OpenTypeCollectionViewCell.cellIdentifier, for: indexPath) as? OpenTypeCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(openType: openType)
            return cell
        })
    }
    
    func configureSnapshot(animatingDifferences: Bool = false) {
        var openTypeCollectionSnapshot = NSDiffableDataSourceSnapshot<Section, CategoryOpenType>()
        openTypeCollectionSnapshot.appendSections([.main])
        openTypeCollectionSnapshot.appendItems(openTypelist, toSection: .main)
        collectionViewDataSource.apply(openTypeCollectionSnapshot, animatingDifferences: animatingDifferences)
    }
    
    private func setupView() {
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill
        self.spacing = 10
        
        [namelabel, openTypeCollecitonView].forEach { self.addArrangedSubview($0) }
        
        openTypeCollecitonView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(50)
        }
        
    }
}
