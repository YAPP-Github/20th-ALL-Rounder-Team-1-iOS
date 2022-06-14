//
//  WCategoryCircle.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/30.
//

import UIKit

class WCategoryTitleLabel: WIconLabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        self.icon.layer.cornerRadius = 3
        self.label.font = WFont.body1()
        self.label.textColor = .gray900
        
        self.stack.spacing = 7
        
        icon.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(icon.snp.height)
        }

    }
    
    init(color: UIColor, title: String) {
        super.init(frame: CGRect.zero)
        
        setupView()
        
        editValue(color: color, title: title)
        
    }
        
}

extension WCategoryTitleLabel {
    
    public func editValue(color: UIColor, title: String) {
        self.icon.backgroundColor = color
        self.label.text = title
    }
}
