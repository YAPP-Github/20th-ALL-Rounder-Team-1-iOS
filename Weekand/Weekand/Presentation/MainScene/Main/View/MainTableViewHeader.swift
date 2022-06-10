//
//  MainTableViewHeader.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/06.
//

import UIKit

class MainTableViewHeader: UITableViewHeaderFooterView {
    
    lazy var calendarView = MainCalendarView()
    
    lazy var dividerLine = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setUpView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpView() {
        self.backgroundColor = .backgroundColor
    }
    
    private func configureUI() {
        
        [ calendarView, dividerLine ].forEach { self.addSubview($0) }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.right.equalToSuperview()
        }
        
        dividerLine.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.top.equalTo(calendarView.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
        
    }
    
    
}
