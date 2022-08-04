//
//  WStatusTimeLabel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/30.
//

import UIKit

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
        self.stack.spacing = 0
        
        self.icon.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
    }
    
    init(status: StatusIcon, title: String) {
        super.init(frame: CGRect.zero)
        
        setupView()
        configureValue(status: status, title: title)
    }
        
}

extension WStatusTimeLabel {
    
    public func configureValue(status: StatusIcon, title: String) {
        
        self.icon.image = UIImage(named: status.rawValue)!.withTintColor(status.tintColor)
        self.label.text = title
    }
}
