//
//  ProfileDetailInteractoinBlockView.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/21.
//

import UIKit
import SnapKit
import Then

/// 팔로워, 팔로잉 블럭
class ProfileDetailInteractoinBlockView: ProfileDetailBlockView {
    
    let icon = UIImage(named: "chevron.right") ?? UIImage(systemName: "chevron.right")
    
    lazy var disclosure = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = icon
    }
    
    override init(title: String) {
        super.init(title: title)
        
        contentLabel.font = WFont.head1()
        
        self.addSubview(disclosure)
        disclosure.snp.makeConstraints { make in
            make.height.equalTo(self.contentLabel.snp.height)
            make.right.equalTo(self.contentLabel.snp.right)
            make.centerY.equalTo(self.contentLabel.snp.centerY)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ProfileDetailInteractoinBlockView {
    
    /// 데이터 설정, 데이터 값에 따라 색상 변경
    func setContentInt(content: Int) {
        super.setContentText(content: String(content))
        
        if content == 0 {
            contentLabel.textColor = .gray400
            disclosure.image = icon?.withTintColor(.gray400)
            self.isUserInteractionEnabled = false
        } else {
            contentLabel.textColor = .gray900
            disclosure.image = icon?.withTintColor(.mainColor)
            self.isUserInteractionEnabled = true
        }
    }
}
