//
//  ProfileDetailHelperView.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/21.
//

import UIKit

/// 프로필 가장 아래 설정 탭
class ProfileDetailHelperView: UIStackView {
    
    let icon = UIImage(named: "chevron.right") ?? UIImage(systemName: "chevron.right")
    
    lazy var titleLabel = UILabel().then {
        $0.font = WFont.subHead2()
    }
    
    lazy var disclosure = UIImageView().then {
        $0.image = icon?.withTintColor(.gray400)
    }
    
    init(_ setting: ProfileSetting) {
        super.init(frame: .zero)
        
        setUpView()
        configureUI()
        
        setData(setting)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.isUserInteractionEnabled = true
        
        self.axis = .horizontal
        self.spacing = 0
        self.distribution = .fill
        self.alignment = .center
        
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
    }
    
    private func configureUI() {
        [titleLabel, disclosure].forEach { self.addArrangedSubview($0) }
    }
    
}

extension ProfileDetailHelperView {
    
    func setData(_ setting: ProfileSetting) {
        titleLabel.text = setting.rawValue
        
        if setting.isCritical {
            titleLabel.textColor = .gray400
            disclosure.isHidden = true
        } else {
            titleLabel.textColor = .gray900
            disclosure.isHidden = false
        }

    }
}
