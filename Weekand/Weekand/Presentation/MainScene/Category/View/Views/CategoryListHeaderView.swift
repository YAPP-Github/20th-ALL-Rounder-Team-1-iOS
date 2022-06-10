//
//  CategoryListHeaderView.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/10.
//

import UIKit

class CategoryListHeaderView: UITableViewHeaderFooterView {

    static let cellIdentifier = "CategoryListHeaderCell"
    
    lazy var addCategoryButton = UIButton().then {
        $0.backgroundColor = .subColor
        $0.layer.cornerRadius = 8
        let buttonImage = UIImage(named: "addCategory")
        $0.setImage(buttonImage, for: .normal)
    }
    
    lazy var filterButton = WFilterButton().then {
        $0.setTitle("내림차순")
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
    }
    
    func configureUI() {
        self.contentView.addSubview(addCategoryButton)
        self.contentView.addSubview(filterButton)
        
        addCategoryButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.leading.equalTo(24)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        filterButton.snp.makeConstraints { make in
            make.trailing.equalTo(-12)
            make.width.equalTo(86)
            make.height.equalTo(41)
            make.centerY.equalTo(self.snp.centerY)
        }
    }

}
