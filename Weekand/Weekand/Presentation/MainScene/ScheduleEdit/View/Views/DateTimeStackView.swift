//
//  DateTimeStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/04.
//

import UIKit
import FSCalendar
import Then

class DateTimeStackView: UIStackView {
    
    lazy var namelabel = WTextLabel().then {
        $0.textColor = UIColor.gray800
    }
    
    lazy var dateButton = WFilledGrayButton(title: "", font: WFont.body1())
    lazy var timeButton = WFilledGrayButton(title: "", font: WFont.body1())
    
    lazy var datePickerContainerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var timePickerContainerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var timePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = .time
    }
    
    lazy var datePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .inline
        $0.datePickerMode = .date
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
        
        self.timePickerContainerView.isHidden = true
        self.datePickerContainerView.isHidden = true
        
        [namelabel, stackView, datePickerContainerView, timePickerContainerView].forEach { self.addArrangedSubview($0) }
        
        [dateButton, timeButton].forEach { stackView.addArrangedSubview($0) }
        
        datePickerContainerView.addSubview(calendarView)
        timePickerContainerView.addSubview(timePicker) 
        
        datePickerContainerView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(350)
        }
        
        calendarView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        timePickerContainerView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(180)
        }
    }
    
    init(nameText: String, dateText: String, timeText: String) {
        super.init(frame: CGRect.zero)
        
        self.namelabel.text = nameText
        self.dateButton.setTitle(dateText, for: .normal, font: WFont.body1())
        self.timeButton.setTitle(timeText, for: .normal, font: WFont.body1())
        setupView()
    }
    
    

}
