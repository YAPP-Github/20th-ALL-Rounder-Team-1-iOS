//
//  DateStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/26.
//

import UIKit
import FSCalendar
import Then

class DateStackView: UIStackView {
    
    lazy var namelabel = WTextLabel().then {
        $0.textColor = UIColor.gray800
        $0.text = "일자"
    }
    
    lazy var dateButton = WFilledGrayButton(title: "", font: WFont.body1())
    
    lazy var calendarContainerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var calendarView = WCalendarView()
    
    lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 10
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 10
        
        self.calendarContainerView.isHidden = true
        
        [namelabel, stackView, calendarContainerView].forEach { self.addArrangedSubview($0) }
        
        [dateButton].forEach { stackView.addArrangedSubview($0) }
        
        calendarContainerView.addSubview(calendarView)
        
        calendarContainerView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(350)
        }
        
        calendarView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
