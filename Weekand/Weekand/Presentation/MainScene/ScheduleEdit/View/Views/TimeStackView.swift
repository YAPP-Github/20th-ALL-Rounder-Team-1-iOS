//
//  DateTimeStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/04.
//

import UIKit
import Then

class TimeStackView: UIStackView {
    
    lazy var namelabel = WTextLabel().then {
        $0.textColor = UIColor.gray800
        $0.text = "시간"
    }
    
    lazy var startTimeButton = WFilledGrayButton(title: "", font: WFont.body1())
    lazy var endTimeButton = WFilledGrayButton(title: "", font: WFont.body1())
    
    lazy var startTimePickerContainerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var endTimePickerContainerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var startTimePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = .time
    }
    
    lazy var endTimePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = .time
    }
    
    lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
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
        
        self.endTimePickerContainerView.isHidden = true
        self.startTimePickerContainerView.isHidden = true
        
        [namelabel, stackView, startTimePickerContainerView, endTimePickerContainerView].forEach { self.addArrangedSubview($0) }
        
        [startTimeButton, endTimeButton].forEach { stackView.addArrangedSubview($0) }
        
        startTimePickerContainerView.addSubview(startTimePicker)
        endTimePickerContainerView.addSubview(endTimePicker) 
        
        startTimePickerContainerView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(200)
        }
        
        endTimePickerContainerView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(200)
        }
    }

}
