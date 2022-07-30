//
//  WCalendar.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/07.
//

import UIKit
import FSCalendar

class WCalendarView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    lazy var headerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = WFont.subHead1()
        $0.text = dateFormatter.string(from: Date())
    }
    
    lazy var leftButton = UIButton().then {
        $0.setImage(UIImage(named: "arrow.left")?.withTintColor(.gray500) ?? UIImage(systemName: "arrowtriangle.left.fill"), for: .normal)
        $0.tintColor = .gray500
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    lazy var rightButton = UIButton().then {
        $0.setImage(UIImage(named: "arrow.right")?.withTintColor(.gray500) ?? UIImage(systemName: "arrowtriangle.right.fill")!, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    lazy var calendar = FSCalendar().then {
        $0.locale = Locale(identifier: "Ko_KR")
        $0.scope = .month
        
        $0.scrollEnabled = false
        $0.scrollDirection = .horizontal
    
        $0.appearance.headerTitleAlignment = .center
        $0.headerHeight = 0
        
        $0.appearance.weekdayFont = WFont.body2()
        $0.appearance.weekdayTextColor = .gray400
        
        $0.appearance.titleFont = WFont.body2()
        
        $0.appearance.titleTodayColor = .mainColor
        $0.appearance.todayColor = .clear
        $0.appearance.todaySelectionColor = .none
        
        $0.appearance.titleDefaultColor = .gray900
        $0.appearance.selectionColor = .mainColor
        
        $0.select(Date())
    }
    
    lazy var dateFormatter = DateFormatter().then {
        $0.dateFormat = "YYYY년 M월"
        $0.locale = Locale(identifier: "Ko_KR")
    }
    
    private func setupView() {
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = 10
        
        self.addArrangedSubview(headerStackView)
        self.addArrangedSubview(calendar)
        
        self.leftButton.addTarget(self, action: #selector(tapLastMonth), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(tapNextMonth), for: .touchUpInside)
        
        [titleLabel, leftButton, rightButton].forEach { headerStackView.addArrangedSubview($0) }
        
        headerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(13)
            make.height.equalTo(50)
        }
        
        leftButton.snp.makeConstraints { make in
            make.width.equalTo(44)
        }
        
        rightButton.snp.makeConstraints { make in
            make.width.equalTo(44)
        }
        
        calendar.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(300)
        }
    }
}

extension WCalendarView {
    
    @objc func tapNextMonth() {
        self.scrollCurrentPage(isNext: false)
    }
    
    @objc func tapLastMonth() {
        self.scrollCurrentPage(isNext: true)
    }
    
    private func scrollCurrentPage(isNext: Bool) {
        var dateComponents = DateComponents()
        dateComponents.month = isNext ? -1 : 1
        
        let date = Calendar.current.date(byAdding: dateComponents, to: calendar.currentPage) ?? Date()
            
        calendar.currentPage = date
        calendar.setCurrentPage(calendar.currentPage, animated: true)
        
        titleLabel.text = dateFormatter.string(from: date)
    }
}
