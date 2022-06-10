//
//  CategoryDetailHeaderView.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/11.
//

import UIKit

class CategoryDetailHeaderView: UITableViewHeaderFooterView {

    static let cellIdentifier = "CategoryDetailHeaderCell"
    
    lazy var searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
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
        self.contentView.addSubview(searchBar)
        self.contentView.addSubview(filterButton)
        
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalToSuperview().offset(15)
        }

        filterButton.snp.makeConstraints { make in
            make.bottom.equalTo(-10)
            make.trailing.equalTo(-12)
            make.width.equalTo(86)
            make.height.equalTo(41)
        }
    }

}
