//
//  OpenTypeCollectionViewCell.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/31.
//

import UIKit
import RxSwift

class OpenTypeCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "OpenTypeCell"

    private let disposeBag = DisposeBag()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                label.backgroundColor = .subColor
                label.textColor = .mainColor
            } else {
                label.backgroundColor = .gray100
                label.textColor = .gray400
            }
        }
    }
    
    let edgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    lazy var label = BasePaddingLabel(padding: edgeInsets).then {
        $0.font = WFont.subHead3()
        $0.textColor = .gray400
        $0.backgroundColor = .gray100
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(openType: CategoryOpenType) {
        label.text = openType.description
    }
    
}
