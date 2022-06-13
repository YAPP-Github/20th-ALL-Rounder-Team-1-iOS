//
//  InformationCollectionViewCell.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/12.
//

import UIKit
import SnapKit

class InformationCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "InformationCell"
    
    lazy var button = WDefaultButton(title: "설마마", style: .tag, font: WFont.body2())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    }
    
}
