//
//  InformationCollectionViewCell.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/12.
//

import UIKit
import SnapKit
import RxSwift

protocol InformationCellDelegate: AnyObject {
    func cellTapped(tag: String?)
}

class InformationCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    static let cellIdentifier = "InformationCell"
    
    var delegate: InformationCellDelegate?
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
    
    let edgeInsets = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)
    lazy var label = BasePaddingLabel(padding: edgeInsets).then {
        $0.font = WFont.body2()
        $0.textColor = .gray400
        $0.backgroundColor = .gray100
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
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
    
    func configure(text: String) {
        label.text = text
    }
    
}
