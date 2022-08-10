//
//  ProfileDetailCollectionStackView.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/22.
//

import UIKit
import AlignedCollectionViewFlowLayout

/// 제목 + 컬렉션뷰
class ProfileDetailCollectionStackView: UIStackView {
    
    let collectionViewFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top).then {
        $0.minimumInteritemSpacing = 9
        $0.estimatedItemSize = CGSize(width: 53, height: 38)
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = WFont.head2()
        $0.textColor = .gray700
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    
    var cellContent: [String] = []
    
    init() {
        super.init(frame: .zero)
        
        setUpView()
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.axis = .vertical
        self.spacing = 0
        self.distribution = .fillEqually
        
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.register(ProfileDetailCollectionCell.self, forCellWithReuseIdentifier: ProfileDetailCollectionCell.cellIdentifier)
    }
    
    private func configureUI() {
        
        [titleLabel, collectionView].forEach { self.addArrangedSubview($0) }
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        collectionView.setContentHuggingPriority(.required, for: .vertical)
        collectionView.setContentCompressionResistancePriority(.required, for: .vertical)
        collectionView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(53)
        }
        
    }
}

extension ProfileDetailCollectionStackView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if cellContent.isEmpty {
            return 1
        } else {
            return cellContent.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileDetailCollectionCell.cellIdentifier, for: indexPath) as? ProfileDetailCollectionCell else { return UICollectionViewCell() }
        
        
        if cellContent.isEmpty {
            cell.setData(title: nil)
        } else {
            cell.setData(title: cellContent[indexPath.item])
        }
        
        return cell
    }
    
}

extension ProfileDetailCollectionStackView {
    func setData(title: String, content: [String]) {
        titleLabel.text = title
        cellContent = content
        
        collectionView.reloadData()
    }
}
