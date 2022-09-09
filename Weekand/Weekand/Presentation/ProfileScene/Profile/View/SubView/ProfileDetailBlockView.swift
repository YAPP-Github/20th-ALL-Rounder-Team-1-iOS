//
//  ProfileDetailBlockView.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/21.
//

import UIKit

/// 프로필 흰색 둥근 사각형 부분
class ProfileDetailBlockView: UIStackView {
    
    /// 정보 이름 (한줄목표, 팔로잉, 팔로워)
    lazy var titleLabel = UILabel().then {
        $0.font = WFont.body2()
        $0.textColor = .gray600
    }
    
    /// 정보 내용
    lazy var contentLabel = UILabel().then {
        $0.font = WFont.body1()
        $0.textColor = .gray900
    }
    
    init(title: String) {
        super.init(frame: .zero)
        setUpView()
        configureUI()
        
        titleLabel.text = title
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.spacing = 8
        self.axis = .vertical
        self.distribution = .fill
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16)
    }
    
    private func configureUI() {
        [titleLabel, contentLabel].forEach { self.addArrangedSubview($0) }
    }
}

extension ProfileDetailBlockView {
    
    /// Content Label의 text 설정
    func setContentText(content: String) {
        contentLabel.text = content
    }
}
