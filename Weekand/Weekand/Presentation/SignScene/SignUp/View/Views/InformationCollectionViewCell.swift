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
    
    lazy var button = WTagToggleButton(title: "", font: WFont.body2())
    var tagValue: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bindGesture()
        self.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(text: String) {
        button.setTitle(text, for: .normal, font: WFont.body2())
        tagValue = text
    }
    
    // MARK: Gesture Binding
    private func bindGesture() {
        
        button.rx.tapGesture(configuration: { recognizer, _ in
            recognizer.delegate = self
        })
        .when(.recognized)
        .subscribe(onNext: { _ in
            self.delegate?.cellTapped(tag: self.tagValue)
        }).disposed(by: disposeBag)
    }
    
}
