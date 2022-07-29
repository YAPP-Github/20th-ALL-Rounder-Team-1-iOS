//
//  CategoryListHeaderView.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/10.
//

import UIKit
import DropDown

class CategoryListHeaderView: UITableViewHeaderFooterView {

    static let cellIdentifier = "CategoryListHeaderCell"
    
    lazy var addCategoryButton = UIButton().then {
        $0.backgroundColor = .subColor
        $0.layer.cornerRadius = 8
        let buttonImage = UIImage(named: "folder.plus")?.withTintColor(.mainColor)
        $0.setImage(buttonImage, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    let sortButton = WSortButton()
    
    lazy var dropDown = DropDown(anchorView: sortButton).then {
        $0.bottomOffset = CGPoint(x: -35, y: 40)
        $0.backgroundColor = .white
        $0.textFont = WFont.body1()
        $0.selectionBackgroundColor = .gray100
        $0.cornerRadius = 10
        $0.width = 118
        $0.cellHeight = 46
        $0.shadowOpacity = 0.1
        $0.layer.borderColor = UIColor.gray200.cgColor
        $0.layer.borderWidth = 1
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
        sortButton.showsMenuAsPrimaryAction = true
        if #available(iOS 14.0, *) {
            var backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
            backgroundConfiguration.backgroundColor = UIColor.clear
            self.backgroundConfiguration = backgroundConfiguration
        }
        
    }
    
    func configureUI() {
        self.contentView.addSubview(addCategoryButton)
        self.contentView.addSubview(sortButton)
        
        addCategoryButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.leading.equalTo(24)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        sortButton.snp.makeConstraints { make in
            make.trailing.equalTo(-12)
            make.width.equalTo(86)
            make.height.equalTo(41)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

}
