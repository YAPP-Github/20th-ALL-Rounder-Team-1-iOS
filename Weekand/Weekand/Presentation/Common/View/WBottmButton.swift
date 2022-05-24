//
//  WBottmButton.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/23.
//

import UIKit

class WBottmButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        
        self.titleLabel?.adjustsFontForContentSizeCategory = true
        self.titleLabel?.font = UIFont(name: "PretendardVariable-SemiBold", size: defaultFontSize)
        
        self.contentVerticalAlignment = .top
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.background.backgroundColor = UIColor.mainColor
            configuration.background.cornerRadius = 0
            configuration.contentInsets.top = NSDirectionalEdgeInsets.defaultInsetAmount
            self.configuration = configuration
            
        } else {
            
            self.layer.cornerRadius = 0
            self.backgroundColor = UIColor.mainColor
            self.setTitleColor(.white, for: .normal)
            self.contentEdgeInsets.top = UIEdgeInsets.defaultInsetAmount
        }
    }
    
}

extension WBottmButton {
    static let buttonOffset = 64
}
