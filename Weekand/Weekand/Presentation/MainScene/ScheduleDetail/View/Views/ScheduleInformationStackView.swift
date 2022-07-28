//
//  ScheduleInformationStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/28.
//

import UIKit

class ScheduleInformationStackView: UIStackView {

    lazy var titleLabel = WTextLabel().then {
        $0.textColor = UIColor.gray400
        $0.font = WFont.body2()
    }

    lazy var textLabel = WTextLabel().then {
        $0.textColor = UIColor.gray900
        $0.font = WFont.body1()
        $0.numberOfLines = 0
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
        
        [titleLabel, textLabel].forEach { self.addArrangedSubview($0) }
    }
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        
        self.titleLabel.text = title
        setupView()
    }
    
    func configure(text: String) {
        self.textLabel.text = text
    }

}
