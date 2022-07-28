//
//  ScheduleCompleteToolBar.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/29.
//

import UIKit

class ScheduleCompleteToolBar: UIToolbar {
    
    let viewHeight = 100
    
    lazy var scheduleCountLabel = UILabel().then {
        $0.textColor = .mainColor
        $0.font = WFont.body2()
    }
    
    let incompletedButton = WDefaultButton(title: "미완료", style: .filled, font: WFont.subHead1())
    let completedButton = WDefaultButton(title: "완료", style: .tint, font: WFont.subHead1())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        self.barTintColor = .white
        self.clipsToBounds = true
        self.layer.borderWidth = 0
    }
    
    func configureUI() {
        self.addSubview(incompletedButton)
        self.addSubview(completedButton)
        
        incompletedButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(160)
            make.height.equalTo(50)
        }
        
        completedButton.snp.makeConstraints { make in
            make.leading.equalTo(incompletedButton.snp.trailing).offset(10)
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(160)
            make.height.equalTo(50)
        }
    }
}
