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

protocol MainCalendarDelegate: AnyObject {
    func didSelectCalendar(date: Date)
}

/// 메인 화면 주간 캘린더 + 위쪽 버튼
class MainCalendarView: UIView {
    
    private var currentPage: Date?
    var delegate: MainCalendarDelegate?
    
    // MARK: UI Properties
    fileprivate weak var calendar: FSCalendar!
    
    lazy var titleLabel = UILabel().then {
        $0.font = WFont.body1()
        $0.isUserInteractionEnabled = true
    }
    
    lazy var leftButton = UIButton().then {
        $0.setImage(UIImage(named: "arrow.left") ?? UIImage(systemName: "arrowtriangle.left.fill"), for: .normal)
        $0.tintColor = .gray500
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    lazy var rightButton = UIButton().then {
        $0.setImage(UIImage(named: "arrow.right") ?? UIImage(systemName: "arrowtriangle.right.fill")!, for: .normal)
        $0.tintColor = .gray500
        $0.imageView?.contentMode = .scaleAspectFit
    }

    lazy var todayButton = WDefaultButton(title: "오늘", style: .tint, font: WFont.body3()).then {
        
        if #available(iOS 15.0, *) {
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            $0.configuration?.background.cornerRadius = 8
        } else {
            $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            $0.layer.cornerRadius = 8
        }
    }
    
    lazy var editButton = UIButton().then {
        $0.setImage(UIImage(named: "edit")?.withTintColor(.gray600), for: .normal)
        $0.tintColor = .gray600
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    lazy var titleBar = UIView()
    
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
        self.changeTitle(date: Date())
    }
    
    // MARK: configureUI
    private func configureUI() {
        
        // Inside Title Header
        [ titleLabel, rightButton, leftButton, todayButton, editButton ].forEach {
            titleBar.addSubview($0)
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(9)
        }
        leftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(titleLabel.snp.left).offset(-15)
            make.height.equalToSuperview()
            make.width.equalTo(leftButton.snp.height).dividedBy(2)
        }
        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(15)
            make.height.equalToSuperview()
            make.width.equalTo(leftButton.snp.height).dividedBy(2)
        }
        todayButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        editButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(titleLabel.snp.height)
            make.width.equalTo(leftButton.snp.height)
        }
        
        // Inside Stack View
        [ titleBar, calendar ].forEach { stack.addArrangedSubview($0) }
        titleBar.setContentHuggingPriority(.required, for: .vertical)
        titleBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        calendar.setContentCompressionResistancePriority(.required, for: .vertical)
        calendar.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.left.right.equalToSuperview()
        }
        
        self.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}

// MARK: Calander
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
        calendar.appearance.selectionColor = .mainColor
        
        // 오늘 날짜 Select
        calendar.select(Date())
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        
        self.layoutSubviews()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        self.changeTitle(date: date)
        self.calendar.setCurrentPage(date, animated: true)
        
        self.delegate?.didSelectCalendar(date: date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let page = calendar.currentPage
        changeTitle(date: page)
    }
    
}

// 날짜 설정
extension MainCalendarView {
    
    /// 오늘 날짜로 이동
    public func selectDate(date: Date) {
        self.calendar.setCurrentPage(date, animated: true)
        self.calendar.select(date)
    }
    
    public func scrollWeek(isNext: Bool) {
        
        var dateComponents = DateComponents()
        dateComponents.day = isNext ? +7 : -7
        
        currentPage = calendar.currentPage
        
        self.currentPage = Calendar.current.date(byAdding: dateComponents, to: self.currentPage ?? Date())
        self.calendar.setCurrentPage(self.currentPage!, animated: true)
    }
    
    /// 캘린더 타이틀(월 표시) 변경
    private func changeTitle(date: Date) {
        
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M"
            
            return dateFormatter
        }()
        
        titleLabel.text = "\(dateFormatter.string(from: date))월"
    }
    
}
