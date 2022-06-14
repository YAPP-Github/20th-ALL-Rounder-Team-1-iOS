//
//  WStatusTimeLabel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/30.
//

import UIKit

enum StatusIcon: String {
    
    // TODO: String 대신 tintColor로 랜더링된 UIImage를 받을 수 있도록 리팩토링
    case upcoming = "state.upcomming"
    case proceeding = "state.proceeding"
    case completed = "state.completed"
    case skipped = "state.start"
    
    case start = "date.start"
    case end = "date.end"
}

class WStatusTimeLabel: WIconLabel {

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
    
    init(status: StatusIcon, title: String) {
        super.init(frame: CGRect.zero)
        
        setupView()
        configureValue(status: status, title: title)
    }
        
}

extension WStatusTimeLabel {
    
    public func configureValue(status: StatusIcon, title: String) {
        
        self.icon.image = UIImage(named: status.rawValue)!.withTintColor(.gray400)
        self.label.text = title
    }
}
