//
//  CategoryDetailToolBar.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/11.
//

import UIKit

class CategoryDetailToolBar: UIToolbar {
    
    let viewHeight = 50
    
    lazy var scheduleCountLabel = UILabel().then {
        $0.textColor = .mainColor
        $0.font = WFont.body2()
    }
    
    lazy var updateCategoryButton = UIButton().then {
        $0.backgroundColor = .subColor
        $0.layer.cornerRadius = 8
        let buttonImage = UIImage(named: "category.update")?.withTintColor(.mainColor)
        $0.setImage(buttonImage, for: .normal)
    }
    
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
        self.addSubview(scheduleCountLabel)
        self.addSubview(updateCategoryButton)
        
        scheduleCountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalToSuperview().offset(13)
        }
        
        updateCategoryButton.snp.makeConstraints { make in
            make.height.width.equalTo(35)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
        }
    }

    func setScheduleCount(_ count: Int) {
        scheduleCountLabel.text = "\(count)개의 일정"
    }
}
