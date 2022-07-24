//
//  ProfileDetailCollectionCell.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/22.
//

import UIKit
import SnapKit

class ProfileDetailCollectionCell: UICollectionViewCell {

    static let cellIdentifier = "InformationCell"
    
    let icon = (UIImage(named: "plus.circle.fill") ?? UIImage(systemName: "plus.circle.fill"))?.withTintColor(.gray400)
    
    lazy var iconImageView = UIImageView(image: icon)
    
    lazy var label = UILabel().then {
        $0.font = WFont.body2()
    }
    
    lazy var parentStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fill

        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUpView()
        configureUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpView() {
        self.contentView.layer.cornerRadius = 15
        self.contentView.clipsToBounds = true
    }
    
    private func configureUI() {
        
        [iconImageView, label].forEach { parentStack.addArrangedSubview($0) }
        iconImageView.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.width.equalTo(16)
        }
        
        self.contentView.addSubview(parentStack)
        parentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ProfileDetailCollectionCell {
    
    func setData(title: String?) {
        
        if let title = title {
            self.contentView.backgroundColor = .subColor
            label.textColor = .mainColor
            label.text = title
            iconImageView.isHidden = true
        } else {
            self.contentView.backgroundColor = .gray100
            label.textColor = .gray400
            label.text = "추가하러 가기"
            iconImageView.isHidden = false
        }
    }
}
