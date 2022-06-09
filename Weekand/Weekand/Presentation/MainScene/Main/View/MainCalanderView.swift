//
//  MainCalanderView.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/06.
//

import UIKit
import SnapKit
import Then
import FSCalendar

class MainCalanderView: UIView {
    
    lazy var calander = FSCalendar().then {
        
        // Base
        $0.scope = .week
        $0.locale = Locale(identifier: "ko_KR")
        $0.scrollEnabled = true
        $0.scrollDirection = .horizontal
        
        // Header Title
        $0.headerHeight = 0
        
        // 일 월 화 수 목 금 토
        $0.appearance.weekdayFont = WFont.body3()
        $0.appearance.weekdayTextColor = .gray400
        
        // 날짜
        $0.appearance.titleFont = WFont.body2()
        $0.appearance.todayColor = .backgroundColor
        $0.appearance.titleTodayColor = .mainColor
        
        
        // Selection
        $0.allowsSelection = true
        $0.allowsMultipleSelection = false
        $0.appearance.borderRadius = 20
        
        $0.setContentHuggingPriority(.required, for: .vertical)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        configureUI()
    }
    
    
    private func setupView() {
        calander.delegate = self
        calander.dataSource = self
    }
    
    private func configureUI() {
        self.addSubview(calander)
        calander.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18))
        }
    }
    
}

extension MainCalanderView {
    
}


extension MainCalanderView: FSCalendarDelegate, FSCalendarDataSource {
    
}
