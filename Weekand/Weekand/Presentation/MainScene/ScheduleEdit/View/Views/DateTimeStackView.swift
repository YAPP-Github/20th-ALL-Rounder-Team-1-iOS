//
//  DateTimeStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/04.
//

import UIKit
import FSCalendar
import Then

class DateTimeStackView: UIView {

    lazy var mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 10
    }
    
    lazy var namelabel = WTextLabel().then {
        $0.textColor = UIColor.gray800
    }
    
    lazy var dateButton = WFilledGrayButton(title: "", font: WFont.body1())
    lazy var timeButton = WFilledGrayButton(title: "", font: WFont.body1())
    
    lazy var timePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = .time
    }
    
    lazy var calendar = FSCalendar().then {
        $0.scope = .month
    }
    
    lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 10
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
//        self.calendar.isHidden = true
        self.timePicker.isHidden = true
        
        self.addSubview(mainStackView)
        [namelabel, stackView, calendar, timePicker].forEach { mainStackView.addArrangedSubview($0) }
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [dateButton, timeButton].forEach { stackView.addArrangedSubview($0) }
    }
    
    init(nameText: String, dateText: String, timeText: String) {
        super.init(frame: CGRect.zero)
        
        self.namelabel.text = nameText
        self.dateButton.setTitle(dateText, for: .normal, font: WFont.body2())
        self.timeButton.setTitle(timeText, for: .normal, font: WFont.body2())
        setupView()
    }

}
