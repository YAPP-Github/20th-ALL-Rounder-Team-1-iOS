//
//  InformationGroupStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/05/25.
//

import UIKit
import AlignedCollectionViewFlowLayout

class InformationGroupStackView: UIStackView {

    lazy var informationStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    lazy var namelabel = WTextLabel().then {
        $0.textColor = UIColor.gray800
        $0.font = WFont.head2()
    }
    
    lazy var informlabel = WTextLabel().then {
        $0.textColor = UIColor.gray500
        $0.font = WFont.body3()
    }
    
    lazy var collectionViewFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top).then {
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 7
        $0.estimatedItemSize = CGSize(width: 53, height: 38)
        $0.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        axis = .vertical
        spacing = 15
        informationStackView.spacing = 5
        
        [namelabel, informlabel].forEach { informationStackView.addArrangedSubview($0) }
        [informationStackView, collectionView].forEach { self.addArrangedSubview($0) }
        
        collectionView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(270)
        }
        
        namelabel.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
    }
    
}

extension InformationGroupStackView {
    func setNameLabelText(string: String) {
        namelabel.text = string
    }
    
    func setInformlabelText(string: String) {
        informlabel.text = string
    }
}
