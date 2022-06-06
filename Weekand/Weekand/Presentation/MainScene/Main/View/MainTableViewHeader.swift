//
//  MainTableViewHeader.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/06.
//

import UIKit

class MainTableViewHeader: UITableViewHeaderFooterView {
    
//    lazy var button = WDefaultButton(title: "Header", style: .filled)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setUpView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpView() {
        self.backgroundColor = .brown
    }
    
    private func configureUI() {
        
//        self.addSubview(button)
//        button.snp.makeConstraints { make in
//            make.width.equalToSuperview().dividedBy(defaultWidthDivider)
//            make.center.equalToSuperview()
//            make.bottom.greaterThanOrEqualToSuperview().inset(50)
//        }
    }
    
    
}
