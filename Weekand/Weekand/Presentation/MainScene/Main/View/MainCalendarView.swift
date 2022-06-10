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

class MainCalendarView: UIView {
    
    // MARK: UI Properties
    lazy var calendar = FSCalendar().then {
        
        // Base
        $0.scope = .month
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
        
        $0.calendarWeekdayView.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.contentView.setContentCompressionResistancePriority(.required, for: .vertical)
        
//        $0.calendarWeekdayView.backgroundColor = .red
//        $0.contentView.backgroundColor = .blue
//
//        $0.backgroundColor = .subColor
        
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = WFont.body1()
        $0.text = "5월 1주"   // TODO: This is Sample
    }
    
    lazy var leftButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrowtriangle.left.fill")!, for: .normal)
        $0.tintColor = .gray500
    }
    
    lazy var rightButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrowtriangle.right.fill")!, for: .normal)
        $0.tintColor = .gray500
    }

    // TODO: 수정된 WDefaultButton pull 받고 수정 (setTitle 부분)
    lazy var todayButton = WDefaultButton(title: "", style: .tint).then {
        
        if #available(iOS 15.0, *) {
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            
        } else {
            $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        }
        
        let attribute = [NSAttributedString.Key.font: WFont.body3()]
        let attributedTitle = NSAttributedString(string: "오늘", attributes: attribute as [NSAttributedString.Key: Any])
        $0.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    lazy var editButton = UIButton().then {
        $0.setImage(UIImage(systemName: "square.and.pencil")?.withTintColor(.gray600!), for: .normal)
        $0.tintColor = .gray600
    }
    
    lazy var headerView = UIView()
        
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
        calendar.delegate = self
    }
    
    private func configureUI() {
        
        // Constraints
        [ titleLabel, rightButton, leftButton, todayButton, editButton ].forEach { headerView.addSubview($0) }
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        leftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(titleLabel.snp.left).offset(-15)
        }
        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(15)
        }
        todayButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(18)
        }
        editButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-18)
        }
        
        [ headerView, calendar ].forEach { addSubview($0) }
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        calendar.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(14)
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.bottom.equalToSuperview()
            make.height.equalTo(300)
        }
        calendar.setScope(.week, animated: false)
        
        // Buttons
        leftButton.addTarget(self, action: #selector(prevWeek), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(nextWeek), for: .touchUpInside)
        todayButton.addTarget(self, action: #selector(moveToday), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(showEditPage), for: .touchUpInside)
    }
    
}

// MARK: Button Events
extension MainCalendarView {
    
    @objc func prevWeek() {
        print(#function)
    }
    
    @objc func nextWeek() {
        print(#function)
    }
    
    @objc func moveToday() {
        print(#function)
    }
    
    @objc func showEditPage() {
        print(#function)
    }
}

extension MainCalendarView: FSCalendarDelegate {

}
