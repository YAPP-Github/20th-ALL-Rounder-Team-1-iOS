//
//  CategoryDetailFooterView.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/11.
//

import UIKit

class CategoryDetailFooterView: UITableViewHeaderFooterView {

    static let cellIdentifier = "CategoryDetailFooterCell"
    
    lazy var scheduleCountLabel = UILabel().then {
        $0.textColor = .mainColor
        $0.font = WFont.body2()
        $0.text = "nn개의 일정"
    }
    
    lazy var updateCategoryButton = UIButton().then {
        $0.backgroundColor = .subColor
        $0.layer.cornerRadius = 8
        let buttonImage = UIImage(named: "category.update")?.withTintColor(.mainColor)
        $0.setImage(buttonImage, for: .normal)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        self.contentView.backgroundColor = .white
    }
    
    func configureUI() {
        self.contentView.addSubview(scheduleCountLabel)
        self.contentView.addSubview(updateCategoryButton)
        
        scheduleCountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalToSuperview().offset(25)
        }
        
        updateCategoryButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(13)
        }
    }

}
