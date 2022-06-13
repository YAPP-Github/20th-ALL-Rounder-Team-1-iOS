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
    fileprivate weak var calendar: FSCalendar!
    
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
    lazy var todayButton = WDefaultButton(title: "오늘", style: .tint, font: WFont.body3()).then {
        
        if #available(iOS 15.0, *) {
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            
        } else {
            $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        }
    }
    
    lazy var editButton = UIButton().then {
        $0.setImage(UIImage(systemName: "square.and.pencil")?.withTintColor(.gray600!), for: .normal)
        $0.tintColor = .gray600
    }
    
    lazy var headerView = UIView()
    
    lazy var stack = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 10
    }
        
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setUpCalendar()
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setUpCalendar()
        configureUI()
    }
    
    
    // MARK: setupView
    private func setupView() {
        
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        
        self.addSubview(calendar)
        self.calendar = calendar
    }
    
    // MARK: configureUI
    private func configureUI() {
        
        // Inside Title Header
        [ titleLabel, rightButton, leftButton, todayButton, editButton ].forEach {
            headerView.addSubview($0)
        }
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(20)
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
        
        // Inside Stack View
        [ headerView, calendar ].forEach { stack.addArrangedSubview($0) }
        headerView.setContentHuggingPriority(.required, for: .vertical)
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        calendar.setContentCompressionResistancePriority(.required, for: .vertical)
        calendar.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
        
        self.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        // Buttons
        leftButton.addTarget(self, action: #selector(prevWeek), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(nextWeek), for: .touchUpInside)
        todayButton.addTarget(self, action: #selector(moveToday), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(showEditPage), for: .touchUpInside)
    }
    
}

extension MainCalendarView: FSCalendarDelegate, FSCalendarDataSource {
    
    private func setUpCalendar() {
        
        // Base
        calendar.scope = .week
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.scrollEnabled = true
        calendar.scrollDirection = .horizontal

        // Header Title
        calendar.headerHeight = 0

        // 일 월 화 수 목 금 토
        calendar.appearance.weekdayFont = WFont.body3()
        calendar.appearance.weekdayTextColor = .gray400

        // 날짜
        calendar.appearance.titleFont = WFont.body2()
        calendar.appearance.todayColor = .backgroundColor
        calendar.appearance.titleTodayColor = .mainColor

        // Selection
        calendar.allowsSelection = true
        calendar.allowsMultipleSelection = false
        calendar.appearance.borderRadius = 20
        
        // 오늘 날짜 Select
        calendar.select(Date())
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        
        self.layoutSubviews()
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
