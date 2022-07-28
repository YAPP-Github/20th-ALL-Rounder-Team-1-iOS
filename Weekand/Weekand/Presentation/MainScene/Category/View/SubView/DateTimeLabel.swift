//
//  DateLabel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/26.
//

import UIKit

class DateTimeLabel: WIconLabel {
    
    enum DateTime {
        case date
        case time
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        self.label.font = WFont.body2()
        self.label.textColor = .gray400
    }
    
    init(type: DateTime, title: String) {
        super.init(frame: CGRect.zero)
        
        setupView()
        configureValue(type: type, title: title)
    }
        
}

extension DateTimeLabel {
    
    public func configureValue(type: DateTime, title: String) {
        switch type {
        case .date:
            self.icon.image = UIImage(named: "calendar")!
        case .time:
            self.icon.image = UIImage(named: "time")!
        }
        self.label.text = title
    }
}
