//
//  CompleteTableViewCell.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/29.
//

import UIKit
import RxSwift

class CompleteCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "CompleteCell"

    private let disposeBag = DisposeBag()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                label.backgroundColor = .mainColor
                label.textColor = .white
            } else {
                label.backgroundColor = .subColor
                label.textColor = .mainColor
            }
        }
    }
    
    let edgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
    lazy var label = BasePaddingLabel(padding: edgeInsets).then {
        $0.font = WFont.subHead1()
        $0.textColor = .mainColor
        $0.backgroundColor = .subColor
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
    
    func configure(completeStatus: CompleteStatus) {
        switch completeStatus {
        case .complete:
            label.text = "완료"
        case .incomplete:
            label.text = "미완료"
        }
    }
    
}

enum CompleteStatus {
    case complete, incomplete
}
