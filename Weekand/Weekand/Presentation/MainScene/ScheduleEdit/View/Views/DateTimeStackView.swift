//
//  DateTimeStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/04.
//

import UIKit

class DateTimeStackView: UIStackView {

    lazy var namelabel = WTextLabel().then {
        $0.textColor = UIColor.gray800
    }
    
    lazy var dateButton = WFilledGrayButton(title: "", font: WFont.body1())
    lazy var timeButton = WFilledGrayButton(title: "", font: WFont.body1())
    
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

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill
        self.spacing = 10
        
        [namelabel, stackView].forEach { self.addArrangedSubview($0) }
        
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
