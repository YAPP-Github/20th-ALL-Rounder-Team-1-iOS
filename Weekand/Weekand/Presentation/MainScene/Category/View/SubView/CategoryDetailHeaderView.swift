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
        $0.placeholder = "일정을 검색해보세요"
    }
    
    lazy var filterButton = WFilterButton().then {
        $0.setTitle("내림차순")
        $0.backgroundColor = .gray300
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
        self.contentView.addSubview(filterButton)
        
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalToSuperview().offset(12)
        }

        filterButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-5)
            make.trailing.equalToSuperview().offset(-12)
            make.width.equalTo(100)
            make.height.equalTo(42)
        }
    }

}
