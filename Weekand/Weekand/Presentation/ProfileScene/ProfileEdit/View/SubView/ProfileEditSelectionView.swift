//
//  ProfileEditSelectionView.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/25.
//

import Foundation
import UIKit
import SnapKit
import Then

class ProfileEditSelectionView: UIView {
    
    lazy var titleLabel = UILabel().then {
        $0.font = WFont.body2()
        $0.textColor = .gray800
        $0.textAlignment = .left
    }
    
    lazy var labelStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .fill
    }
    
    lazy var labelBackground = UIView().then {
        $0.layer.cornerRadius = defaultCornerRadius
        $0.clipsToBounds = true
        
        $0.backgroundColor = UIColor.lightGray
    }
    
    lazy var selectedLabel = UILabel().then {
        $0.font = WFont.subHead2()
        $0.textAlignment = .left
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        setUpView()
        configureUI()
        
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        selectedLabel.isUserInteractionEnabled = true
    }
    
    private func configureUI() {
        
        [titleLabel].forEach { labelStack.addArrangedSubview($0) }
        
        labelBackground.addSubview(selectedLabel)
        selectedLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16))
        }
        
        [labelStack, labelBackground].forEach { self.addSubview($0) }
        labelStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        labelBackground.snp.makeConstraints { make in
            make.top.equalTo(labelStack.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(52)
        }
        
        
    }
}
