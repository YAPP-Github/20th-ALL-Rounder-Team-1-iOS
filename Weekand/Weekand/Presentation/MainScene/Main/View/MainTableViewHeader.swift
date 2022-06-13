//
//  MainTableViewHeader.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/06.
//

import UIKit

class MainTableViewHeader: UIView {
    
    lazy var calendarView = MainCalendarView()
    
    lazy var dividerLine = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    lazy var stack = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 14
        
        $0.backgroundColor = .backgroundColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpView() {
        
    }
    
    private func configureUI() {
        
        [ calendarView, dividerLine ].forEach { stack.addArrangedSubview($0) }
        dividerLine.snp.makeConstraints { make in
            make.height.equalTo(10)
        }

        self.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.layoutSubviews()
    }
    
}
