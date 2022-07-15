//
//  SearchHeaderView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/15.
//

import UIKit
import DropDown


class SearchHeaderView: UITableViewHeaderFooterView {

    static let cellIdentifier = "UserSearchHeaderCell"
    
    lazy var searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
        $0.placeholder = "친구·한줄목표를 검색해보세요"
    }
    
    lazy var sortButton = WSortButton().then {
        $0.setTitle("최신순")
        $0.backgroundColor = .white
    }
    
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
        self.contentView.backgroundColor = .white
    }
    
    func configureUI() {
        self.contentView.addSubview(searchBar)
        self.contentView.addSubview(sortButton)
        
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalToSuperview().offset(12)
        }

        sortButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-5)
            make.trailing.equalToSuperview().offset(-12)
            make.width.equalTo(100)
            make.height.equalTo(42)
        }
    }
}
