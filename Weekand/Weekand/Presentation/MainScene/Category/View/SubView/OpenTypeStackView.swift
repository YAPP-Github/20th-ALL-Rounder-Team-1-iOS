//
//  OpenTypeStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/11.
//

import UIKit

class OpenTypeStackView: UIStackView {

    lazy var namelabel = WTextLabel().then {
        $0.textColor = UIColor.gray800
    }
    
    let buttonsContainerView = UIView()
    
    let allOpenButton = WTypeToggleButton(title: "전체 공개", style: .checked, font: WFont.subHead3())
    let followerOpenButton = WTypeToggleButton(title: "친구 공개", style: .unchecked, font: WFont.subHead3())
    let closedButton = WTypeToggleButton(title: "비공개", style: .unchecked, font: WFont.subHead3())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill
        self.spacing = 10
        
        [namelabel, buttonsContainerView].forEach { self.addArrangedSubview($0) }
        [allOpenButton, followerOpenButton, closedButton].forEach { buttonsContainerView.addSubview($0) }
        
        allOpenButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.height.equalTo(42)
        }
        
        followerOpenButton.snp.makeConstraints { make in
            make.leading.equalTo(allOpenButton.snp.trailing).offset(12)
            make.top.equalTo(allOpenButton.snp.top)
            make.height.equalTo(42)
        }
        
        closedButton.snp.makeConstraints { make in
            make.leading.equalTo(followerOpenButton.snp.trailing).offset(12)
            make.top.equalTo(allOpenButton.snp.top)
            make.height.equalTo(42)
        }
        
    }
    
    init(nameText: String) {
        super.init(frame: CGRect.zero)
        
        self.namelabel.text = nameText
        setupView()
    }
}
